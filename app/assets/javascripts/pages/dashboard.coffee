class Communit2.Pages.Dashboard

  @currentNewFollowerIndex = 1
  @currentUnfollowerIndex = 1

  @initialize: ->
    @getNewFollower()
    @getNewFollower()
    @getNewFollower()
    @getUnfollower()
    @getUnfollower()
    @getUnfollower()
    @currentNewFollowerIndex--
    @currentUnfollowerIndex--

  @getUnfollower: ->
    @getUnfollowerByIndex(@currentUnfollowerIndex)
    @currentUnfollowerIndex++

  @getUnfollowerByIndex: (index) ->
    $.ajax(
      url: "users/unfollower"
      data: {index: index}
    ).done( (response) =>
      @renderFollower(response, '#new-unfollowers-container')
    )

  @getNewFollower: ->
    @getNewFollowerByIndex(@currentNewFollowerIndex)
    @currentNewFollowerIndex++

  @getNewFollowerByIndex: (index) ->
    $.ajax(
      url: "users/new_follower"
      data: {index: index}
    ).done( (response) =>
      @renderFollower(response, '#new-followers-container')
    )

  @dismissNewFollower: (id) ->
    $.ajax(
      url: "users/dismiss_new_follower"
      data: {id: id, index: @currentNewFollowerIndex}
    ).done( (response) =>
      @renderResponse('#new-followers-container', response, id)
    )

  @dismissUnfollower: (id) ->
    $.ajax(
      url: "users/dismiss_unfollower"
      data: {id: id, index: @currentNewFollowerIndex}
    ).done( (response) =>
      @renderResponse('#new-unfollowers-container', response, id)
    )

  @follow: (id, callbackContainer) ->
    @genericAjax id, callbackContainer, "users/follow"

  @unfollow: (id, callbackContainer) ->
    @genericAjax id, callbackContainer, "users/unfollow"

  @sayHi: (id, callbackContainer) ->
    @genericAjax id, callbackContainer, "users/say_hi"

  @genericAjax: (id, callbackContainer, url)->
    index = @getIndex callbackContainer
    $.ajax(
      url: url
      data: {id: id, index: index, callback_container: callbackContainer}
    ).done( (response) =>
      @renderResponse(callbackContainer, response, id)
    )

  @getIndex: (callbackContainer) ->
    if callbackContainer is '#new-unfollowers-container'
      return @currentUnfollowerIndex
    if callbackContainer is '#new-followers-container'
      return @currentNewFollowerIndex

  @renderResponse: (callbackContainer, response, id) ->
    $("#user-widget-#{id}").fadeOut( 1000, =>
     @renderFollower(response, callbackContainer)
    )

  @renderFollower: (data, container) ->
    if data
      user = new Communit2.Models.User data
      userView = new Communit2.Views.Users model: user
      $(container).append userView.render(container).$el

