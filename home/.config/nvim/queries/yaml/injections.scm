; extends

(block_mapping_pair
  key: (flow_node) @_key
  (#match? @_key "^(script|before_script|after_script)$")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")))
