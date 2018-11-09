function (headers, body) {
    var scriptCode = "function main(request) { return { headers: JSON.parse('" + headers + "')";
    if (body) scriptCode += ", body: JSON.parse('" + body + "')";
    scriptCode += ' }}';
    return scriptCode;
}