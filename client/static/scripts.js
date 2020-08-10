let editorArea;
let consoleArea
let mirrorEditor;
let mirrorConsole;

$(document).ready(function () {
    console.log("Sanity Check!");
    editorArea = document.getElementById("codeEditor");
    editorArea.value = "#include <stdio.h>\n" +
        "int main(int argc, char **argv)\n" +
        "{\n" +
        "  puts(\"Hello, World!\");\n" +
        "  return 0;\n" +
        "}";
    mirrorEditor = CodeMirror.fromTextArea(editorArea, {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-csrc",
        theme: "eclipse"
    });

    consoleArea = document.getElementById("consoleArea");
    mirrorConsole = CodeMirror.fromTextArea(consoleArea, {
        lineNumbers: true,
        mode: "text/x-sh",
        theme: "duotone-dark",
        readOnly: 'nocursor'
    });
});

$('#buildBtn').click(function () {
    console.log("Building starting...");
});

$('#playBtn').click(function () {
    console.log("pasim simulation starting...");
});

$('#stopBtn').click(function () {
    console.log("pasim simulation stopping...");
});

$('#wcetBtn').click(function () {
    console.log("WCET analysis starting...");
});

