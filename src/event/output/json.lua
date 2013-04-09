local json = require 'dkjson'
return {
  handler = function(context)
    context.response.headers["content-type"] = "application/json"

    local output = context.output
    local meta = getmetatable(output)

    if meta and type(meta.__toView) == "function" then
      output = meta.__toView(output, context)
    end

    context.response.send(json.encode(output))
  end,

  options = {
    predicate = function(context)
      local accept = context.request.headers.accept or "application/json"
      local content = context.request.headers["content-type"]

      if type(context.output) == "table" then
        return accept == "application/json" or content == "application/json"
      end

      return false
    end
  }
}
