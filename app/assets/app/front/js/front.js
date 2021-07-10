function strongifyWeekendDiv(element) {
    const STRONG_PATTERNS = [
        { regex: /thursday/ig, class: "weekday" },
        { regex: /friday/ig, class: "weekday" },
        { regex: /saturday/ig, class: "weekday" },
        { regex: /sunday/ig, class: "weekday" },
        { regex: /\d?\d:\d\d/ig, class: "hour" },
        { regex: /"[^\\"]*(\\"[^\\"]*)*"/ig, class: "place" }
    ]

    let previousInnerHTML = element.innerHTML;
    let result = element.textContent;

    STRONG_PATTERNS.forEach(pattern => {
        result = strongifyText(result, pattern);
    });

    // Fixing bug in Firefox when space at the end of the text
    result = result.replace(/&nbsp;/g, " ");
    result = result.replace(/\s$/, "&nbsp;");

    element.innerHTML = result;
}

function strongifyText(text, pattern) {
    return text.replace(pattern.regex, "<strong class='" + pattern.class + "'>$&</strong>");
}

function setCaretPositionAtTheEnd(element) {
    let contentLength = element.textContent.length;
    setCaretPosition(element, contentLength);
}

// From: https://stackoverflow.com/a/65637662/316700
function getCaretPosition(element) {
    let selection = document.getSelection();
    let childOffset = selection.focusOffset;
    let range = document.createRange();
    range.setStart(element, 0);
    range.setEnd(selection.focusNode, childOffset);
    let contentString = range.toString();
    let position = contentString.length;
    return position;
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