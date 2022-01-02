test:
	swift test

update:
	swift package update

clean:
	rm -rf .build

.PHONY: build install uninstall clean
