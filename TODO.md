## TODO

## Webpacker & Vue

- config/initializers/content_security_policy.rb: script is unsafe_eval because of Vue. Better to remove it.
- config/webpacker/resolve/vue.js: use runtime Vue to avoid CSP. See whether it improves or not.
