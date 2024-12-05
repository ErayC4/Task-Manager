document.addEventListener("DOMContentLoaded", () => {
    let selectedTask = null;

    const tasks = document.querySelectorAll(".task");
    tasks.forEach(task => {
        task.addEventListener("click", (event) => {
            const clickedTaskId = event.target.id;

            // 1. Task skalieren und alte Skalierung entfernen
            if (selectedTask) {
                selectedTask.style.transform = "scaleX(1)";
            }
            selectedTask = event.target;
            selectedTask.style.transform = "scaleX(1.1)";
            const taskTitle = event.target.textContent.trim();
            displayTaskName(taskTitle);
            // 2. Editor für den aktuellen Task anzeigen
            showEditorForTask(clickedTaskId);

            // 3. Table of Contents für den aktuellen Task aktualisieren
            showTableOfContentsForTask(clickedTaskId);
        });
    });

    function showEditorForTask(taskId) {
        const editors = document.querySelectorAll(".editor-js");
        editors.forEach(editor => {
            editor.style.display = "none";
        });

        const editorToShow = document.getElementById(`editorjs-${taskId}`);
        if (editorToShow) {
            editorToShow.style.display = "block";
        }
    }

    function displayTaskName(taskTitle) {
        // Finde das Element, wo der Titel angezeigt werden soll
        const taskNameElement = document.querySelector(".table-of-contents-header p");
        if (taskNameElement) {
            taskNameElement.textContent = taskTitle;
        }
    }

    function showTableOfContentsForTask(taskId) {
        const tables = document.querySelectorAll(".table-of-contents");
        tables.forEach(table => {
            if (table.getAttribute("data-task-id") === taskId) {
                table.style.display = "block";
            } else {
                table.style.display = "none";
            }
        });
    }

    function selectDefaultTask() {
        let smallestIdTask = null;
        let smallestId = Infinity;

        tasks.forEach(task => {
            const taskId = parseInt(task.id, 10);
            if (taskId < smallestId) {
                smallestId = taskId;
                smallestIdTask = task;
            }
        });

        if (smallestIdTask) {
            smallestIdTask.click(); // Simuliere einen Klick auf den Task
        }
    }

    // Initialisieren
    const editors = document.querySelectorAll(".editor-js");
    editors.forEach(editor => {
        editor.style.display = "none";
    });

    const tables = document.querySelectorAll(".table-of-contents");
    tables.forEach(table => {
        table.style.display = "none";
    });

    selectDefaultTask(); // Default-Task auswählen
});