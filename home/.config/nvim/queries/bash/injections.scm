; extends

(command
  name: (command_name) @_cmd
  (#eq? @_cmd "node")
  argument: (raw_string) @injection.content
  (#set! injection.language "javascript"))
