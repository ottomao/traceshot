var marked = require('marked'),
	http = require('http-request'),
	fs = require('fs')

http.get('https://raw.githubusercontent.com/ottomao/traceshot/master/README.md', function (err, res) {
	if (err) {
		console.error(err);
		return;
	}

	var tpl = fs.readFileSync("./index_tpl.html",{encoding: "utf8"}),
		htmlContent = marked(res.buffer.toString());

	var finalHtml = tpl.replace(/__sectionContent/,htmlContent);

	fs.writeFileSync("./index.html",finalHtml);
	// console.log();
});

