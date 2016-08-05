_ = require 'lodash'


module.exports = class
    view: __dirname
    init: ->
        startsWith = @model.get 'startsWith'
        activeUrl = @model.root.get '$render.url'
        if '?' in activeUrl
            activePath = activeUrl[..activeUrl.indexOf('?')-1]
        else
            activePath = activeUrl
            activeUrl += '?'

        href = encodeURI(@getAttribute('href') || '') || activePath
        query = @model.get 'query'
        if query?
            query = encodeURI query
            @model.set 'active', activeUrl == "#{href}?#{query}"
            @model.set 'url', "#{href}?#{query}"
        else
            @model.set 'url', href
            if startsWith == 'starts-with'
                @model.set 'active', _.startsWith activePath + '/', href + '/'
            else if startsWith
                @model.set 'active', _.startsWith activePath + '/', startsWith + '/'
            else
                @model.set 'active', activePath == href


        if not @onUrlChange
            @onUrlChange = @model.scope('$render').on 'change', 'url', => @init()


    create: ->
        if @getAttribute 'replace'
            @elem.setAttribute 'data-router-ignore', ''
            @dom.on 'click', @elem, (e) =>
                e.preventDefault()
                @app.history.replace @model.get 'url'
