class Communit2.Pages.Dashboard

  @current_new_follower_index = 1
  @current_unfollower_index = 1

  @initialize: ->
    @get_new_follower()
    @get_new_follower()
    @get_new_follower()
    @get_unfollower()
    @get_unfollower()
    @get_unfollower()

  @get_unfollower: ->
    @get_unfollower_by_index(@current_unfollower_index)
    @current_unfollower_index++

  @get_unfollower_by_index: (index) ->
    $.ajax(
      url: "users/unfollower"
      data: {index: index}
    ).done( (response) =>
      @render_follower(response, '#new-unfollowers-container')
    )


  @get_new_follower: ->
    @get_new_follower_by_index(@current_new_follower_index)
    @current_new_follower_index++

  @get_new_follower_by_index: (index) ->
    $.ajax(
      url: "users/new_follower"
      data: {index: index}
    ).done( (response) =>
      @render_follower(response, '#new-followers-container')
    )

  @dismiss_new_follower: (id) ->
    $.ajax(
      url: "users/dismiss_new_follower"
      data: {id: id, index: @current_new_follower_index}
    ).done( (response) =>
      @renderResponse('#new-followers-container', response, id)
    )

  @dismiss_unfollower: (id) ->
    $.ajax(
      url: "users/dismiss_unfollower"
      data: {id: id, index: @current_unfollower_index}
    ).done( (response) =>
      @renderResponse('#new-unfollowers-container', response, id)
    )

  @follow: (id, callbackContainer) ->
    index = if callbackContainer is '#new-unfollowers-container' then @current_unfollower_index else @current_follower_index
    $.ajax(
      url: "users/follow"
      data: {id: id, index: index, callback_container: callbackContainer}
    ).done( (response) =>
      @renderResponse(callbackContainer, response, id)
    )

  @unfollow: (id, callbackContainer) ->
    index = if callbackContainer is '#new-unfollowers-container' then @current_unfollower_index else @current_follower_index
    $.ajax(
      url: "users/unfollow"
      data: {id: id, index: index, callback_container: callbackContainer}
    ).done( (response) =>
      @renderResponse(callbackContainer, response, id)
    )

  @sayHi: (id, callbackContainer) ->
    index = if callbackContainer is '#new-unfollowers-container' then @current_unfollower_index else @current_follower_index
    $.ajax(
      url: "users/say_hi"
      data: {id: id, index: index, callback_container: callbackContainer}
    ).done( (response) =>
      @renderResponse(callbackContainer, response, id)
    )


   @renderResponse: (callbackContainer, response, id) ->
     if callbackContainer is '#new-unfollowers-container' then @current_unfollower_index++
     if callbackContainer is '#new-followers-container' then @current_new_follower_index++
     $("#user-widget-#{id}").fadeOut( 1000, =>
       @render_follower(response, callbackContainer)
     )


  @render_follower: (data, container) ->
    if data
      user = new Communit2.Models.User data
      userView = new Communit2.Views.Users model: user
      $(container).append userView.render(container).$el

