function strongifyWeekendDiv(element) {
    const STRONG_PATTERNS = [
        /thursday/ig,
        /friday/ig,
        /saturday/ig,
        /sunday/ig,
        /\d\d:\d\d/ig,
        /"[^\\"]*(\\"[^\\"]*)*"/g
    ];

    let previousInnerHTML = element.innerHTML;
    let result = element.textContent;

    STRONG_PATTERNS.forEach(regex => {
        result = strongifyText(result, regex);
    });

    element.innerHTML = result;
}

function strongifyText(text, regex) {
    return text.replace(regex, "<strong>$&</strong>");
}

function setCaretPositionAtTheEnd(element) {
    let contentLength = element.textContent.length;
    setCaretPosition(element, contentLength);
}

function getCaretPosition() {
    var sel = document.getSelection();
    sel.modify("extend", "backward", "paragraphboundary");
    var pos = sel.toString().length;
    if (sel.anchorNode != undefined) sel.collapseToEnd();

    return pos;
}

function setCaretPosition(element, desiredPosition) {
    let childNodes = element.childNodes;
    let childIndex = 0;
    let childPosition = 0;
    let position = 0;
    let actualChild = childNodes[0];

    if (actualChild.firstChild) {
        actualChild = actualChild.firstChild;
    }

    while (position < desiredPosition) {
        position += 1;
        childPosition += 1;

        if (childPosition >= actualChild.length && position < desiredPosition) {
            childIndex += 1;
            childPosition = 0;
            actualChild = childNodes[childIndex];

            if (actualChild.firstChild) {
                actualChild = actualChild.firstChild;
            }
        }
    }

    setCaretPositionInChildNode(actualChild, childPosition);
}

function setCaretPositionInChildNode(element, position) {
    var sel = window.getSelection();
    sel.setPosition(element, position);
}

function filterKeys(event) {
    if (event.which === 13) {
        event.preventDefault();
    }
}

function connectInputField(elementId, inputElementId) {
    let element = document.getElementById(elementId);
    let inputElement = document.getElementById(inputElementId);

    element.textContent = inputElement.value;

    element.addEventListener("input", () => { inputElement.value = element.textContent }, false);
}