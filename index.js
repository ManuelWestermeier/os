const fs = require("fs")
const path = require("path")

const inpPath = "src/main.asm"
const outPath = "boot.asm"

function compileFile(inpPath) {
    var data = fs.readFileSync(inpPath, "utf-8")

    const lines = data.split("\r").join("").split("\n")

    return lines.map((line, i) => {

        const [part1, part2, part3] = line.split(" ")

        if (part1 == "@add") {
            return compileFile(path.join(path.dirname(inpPath), part2))
        } else {
            return line
        }

    }).join("\n")
}

require("http").createServer((req, res) => {
    res.writeHead(200, { "content-type": "text/plain" })
    res.end(compileFile(inpPath))
    fs.writeFileSync(outPath, compileFile(inpPath), "utf-8")
}).listen(2000)