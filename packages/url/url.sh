# Encode a string to be used as a URL.
function url_encode() {
	printf %s "${1}" | jq -sRr @uri
}
