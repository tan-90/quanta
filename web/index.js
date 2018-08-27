/*
 * TODO
 * Require relevant Blockly js files instead of using script tags on the page.
 */

/* Inject Blockly into the editor div. */
var workspace = Blockly.inject('editor', {
        media: '../external/blockly/media/',
        toolbox: document.getElementById('toolbox'),
    });

/* 
 * Generate code on every workspace change and output result.
 * The Blockly docs state this is not an expensive operation and can be used for realtime generation. 
 */
workspace.addChangeListener(function(event) {
    var codeOutput = document.getElementById('output-code-generator');
    codeOutput.value = Blockly.quanta.workspaceToCode(workspace);
});

/*
 * Download text as a file.
 */
function download(data, filename) {
    var file = new Blob([data], { type: 'text/plain' });

    // Create a download link for the file.
    var a = document.createElement("a"),
        url = URL.createObjectURL(file);
    a.href = url;
    a.download = filename;

    // Apend it to the DOM.
    document.body.appendChild(a);
    // Click it to trigger a download.
    a.click();

    // Remove the created link.
    setTimeout(function () {
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }, 0);
}

/*
 * Load the workspace from file.
 */
function handleFileSelect(evt) {
    // Get the file input file.
    var file = evt.target.files[0];

    var reader = new FileReader();

    // Load the workspace when the file loads.
    reader.onload = (function (file) {
        return function (e) {
            Blockly.mainWorkspace.clear();
            var xml = Blockly.Xml.textToDom(e.target.result);
            Blockly.Xml.domToWorkspace(xml, Blockly.mainWorkspace);
        };
    })(file);

    reader.readAsText(file);

    // Clear the file input.
    document.getElementById('file-input').value = null;
}

/*
 * TODO
 * Call assembler REST API to assemble current workspace.
 * Redirect assembler output to output field.
 * Download result if successful.
 */
document.getElementById('btn-assemble').addEventListener('click', function onGenerate() {
    /* Get the workspace code as quanta assembly. */
    var code = Blockly.quanta.workspaceToCode(workspace);

    /* Send async request to the assembler API. */
    var request = new XMLHttpRequest();
    request.open('POST', 'http://ec2-18-228-117-206.sa-east-1.compute.amazonaws.com/assembler', true);
    request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    request.send(JSON.stringify({ "program": code }));

    /* Handle response. */
    request.onloadend = function () {
        var resp = JSON.parse(request.response);

        /* Log API response to assembler output. */
        document.getElementById('output-assembler-output').value = resp.output
        if (!resp.error) {
            var name = prompt('Name of the file:', 'quanta2inst');
            if (name) {
                download(resp.assembly, name + '.mif');
            }
        }
    }
});

/*
 * Save current workspace as xml when the save button is clicked.
 */
document.getElementById('btn-save-workspace').addEventListener('click', function() {
    var fileName = prompt('Name of the file:', 'workspace');
    // Only trigger a file save if the prompt was not cancelled.
    if(fileName)
    {
        // Get the current workspace as xml and download it.
        var xml = Blockly.Xml.workspaceToDom(Blockly.mainWorkspace);
        download(Blockly.Xml.domToText(xml),  fileName + '.xml');
    }
});

/*
 * Trigger a click on the file input when the load button is clicked.
 */
document.getElementById('btn-load-workspace').addEventListener('click', function() {
    document.getElementById('file-input').click();
});

/* 
 * Call handle file select on hidden input click.
 * The click is triggered by the load button.
 */
document.getElementById('file-input').addEventListener('change', handleFileSelect, false);

/*
 * Handle info button modal.
 */
document.getElementById('btn-info').addEventListener('click', function(){    
    var modal = document.getElementById('modal-info');
    var close = document.getElementById('modal-info-close');

    modal.style.display = 'block';
    close.style.display = 'block';
});

document.getElementById('modal-info-close').addEventListener('click', function () {
    var modal = document.getElementById('modal-info');
    var close = document.getElementById('modal-info-close');

    modal.style.display = 'none';
    close.style.display = 'none';
});
