recipient := read("./key.pub")

[private]
@default:
	just --list

# Zip and encrypt the contents of the `data/{{name}}/` directory
add-font name:
	zip                     \
		"data/{{name}}.zip" \
		data/{{name}}/*
	age                                  \
		--recipient "{{recipient}}"      \
		--output "data/{{name}}.zip.age" \
		"data/{{name}}.zip"
	rm data/{{name}}.zip
	@echo ""
	@echo "Done -- you can now delete the original 'data/{{name}}' directory"
