.PHONY: test
test:
	bundle exec rspec

.PHONY: lint
lint:
	bundle exec rubocop -a
