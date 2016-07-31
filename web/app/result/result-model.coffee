App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->
  Result.Result = Backbone.Model.extend

    isSuccess: ->
      not @get("exception") and not @get("error")

    execute: ->
      @set 'loading', true

      jqxhr = $.post App.createLink('execute'),
        autoImportDomains: App.settings.get('editor.autoImportDomains')
        code: @get('input')

      jqxhr.done (response) =>
        @set
          loading: false
          totalTime: response.totalTime
          exception: response.exception
          result: response.result
          resultTree: response.resultTree
          output: response.output

      jqxhr.fail =>
        if jqxhr.status
          message = "Server returned #{jqxhr.status}: #{jqxhr.responseText}"
        else
          message = "Server not found."
        @set
          loading: false
          error: message