class AutosaveManager {
  constructor() {
    this.timeouts = new Map();
    this.init();
  }

  init() {
    this.attachListeners();
    
    // Beobachter für DOM-Änderungen
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.addedNodes.length) {
          this.attachListeners();
        }
      });
    });

    // Beobachte den gesamten Body auf Änderungen
    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  }

  attachListeners() {
  const autosaveFields = document.querySelectorAll('.autosave-field, .editor-js');
  
  autosaveFields.forEach(field => {
    if (field.dataset.hasAutosave) return;

    field.dataset.hasAutosave = 'true';

    if (field.classList.contains('editor-js')) {
      // Editor.js hat seinen eigenen Event-Handler, daher hier nichts tun
      return;
    }

    field.addEventListener('input', (e) => this.handleInput(e));
  });
}


  handleInput(event) {
    const field = event.target;
    const taskId = field.dataset.taskId;
    const fieldName = field.dataset.fieldName;
    const fieldValue = field.value;

    // Lösche vorherige Timeouts für dieses Feld
    const timeoutKey = `${taskId}-${fieldName}`;
    if (this.timeouts.has(timeoutKey)) {
      clearTimeout(this.timeouts.get(timeoutKey));
    }

    // Setze neuen Timeout
    const timeoutId = setTimeout(() => {
      this.saveTaskField(taskId, fieldName, fieldValue);
    }, 1000);

    this.timeouts.set(timeoutKey, timeoutId);
  }

  saveTaskField(taskId, fieldName, fieldValue) {
    console.log(`Saving ${fieldName} with value "${fieldValue}" for task ${taskId}`);

    fetch(`/tasks/${taskId}/update_field`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ field_name: fieldName, field_value: fieldValue })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`Network response was not ok: ${response.statusText}`);
      }
      return response.json();
    })
    .then(data => {
      console.log(`${fieldName} saved successfully:`, data);
    })
    .catch(error => {
      console.error(`Error saving ${fieldName}:`, error);
    });
  }
}

// Initialisiere den AutosaveManager
document.addEventListener('DOMContentLoaded', () => {
  window.autosaveManager = new AutosaveManager();
});

document.addEventListener('DOMContentLoaded', () => {
  const editors = []; // Array zum Speichern aller Editor-Instanzen

  document.querySelectorAll('.editor-js').forEach((editorElement) => {
    const taskId = editorElement.dataset.taskId;
    const initialContent = editorElement.dataset.initialContent; // JSON-Inhalt von task.content

    let editorData;
    try {
      // Parse den initialen Inhalt, falls vorhanden
      editorData = initialContent ? JSON.parse(initialContent) : { blocks: [] };
    } catch (e) {
      console.error(`Error parsing initial content for task ${taskId}:`, e);
      editorData = { blocks: [] }; // Fallback auf leere Daten
    }

    const editor = new EditorJS({
      holder: editorElement.id,
      tools: {
        paragraph: { class: Paragraph, inlineToolbar: true },
        header: { class: Header, config: { levels: [2, 3, 4], defaultLevel: 2 } },
        list: { class: List, inlineToolbar: true, config: { defaultStyle: 'unordered' } },
        code: { class: CodeTool }
      },
      data: editorData, // Vorbefüllte Daten
      async onChange() {
        try {
          const outputData = await editor.save();
          const fieldValue = JSON.stringify(outputData);
          const fieldName = 'content';

          // Trigger Autosave
          autosaveManager.saveTaskField(taskId, fieldName, fieldValue);
        } catch (e) {
          console.error('Error saving editor data:', e);
        }
      }
    });

    editors.push(editor);
  });
});
