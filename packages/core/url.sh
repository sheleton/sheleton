# Encode a string to be used as a URL.
function encode_url() {
	printf %s "${1}" | jq -sRr @uri
}
