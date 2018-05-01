define (require) ->
    Raven = require 'raven'

    class ColorMatcher
        @serviceNodeColors: appSettings.service_node_colors

        constructor: (@selectedServiceNodes) ->
        @rgb: (r, g, b) ->
            return "rgb(#{r}, #{g}, #{b})"
        @rgba: (r, g, b, a) ->
            return "rgba(#{r}, #{g}, #{b}, #{a})"
        serviceNodeColor: (serviceNode) ->
            @serviceNodeRootIdColor serviceNode.get('root')
        serviceNodeRootIdColor: (id) ->
            [r, g, b] = @getColor(id)
            @constructor.rgb(r, g, b)
        unitColor: (unit) ->
            roots = unit.get('root_service_nodes')
            if roots is null
                Raven.captureMessage(
                    'No roots found for unit ' + unit.id,
                    tags: type: 'helfi_rest_api_v4')
                roots = [1400]
            if @selectedServiceNodes?
                rootServiceNode = _.find roots, (rid) =>
                    @selectedServiceNodes.find (s) ->
                        s.get('root') == rid
            unless rootServiceNode?
                rootServiceNode = roots[0]
            [r, g, b] = @getColor(rootServiceNode)
            @constructor.rgb(r, g, b)
        getColor: (serviceNodeId) ->
            @constructor.serviceNodeColors?[serviceNodeId] or [0, 0, 0]
    return ColorMatcher
