class Communit2.Pages.Dashboard

  @current_new_follower_index = 1

  @initialize: ->
    @get_new_follower()
    @get_new_follower()
    @get_new_follower()

  @get_new_follower: ->
    @get_new_follower_by_index(@current_new_follower_index)
    @current_new_follower_index++

  @get_new_follower_by_index: (index) ->
    $.ajax(
      url: "users/new_follower"
      data: {index: index}
    ).done( (response) =>
      @render_new_follower(response)
    )

  @dismiss: (id) ->
    $.ajax(
      url: "users/dismiss"
      data: {id: id, index: @current_new_follower_index}
    ).done( (response) =>
      $("#user-widget-#{id}").fadeOut()
      @render_new_follower(response)
    )

  @render_new_follower: (data) ->
    if data
      user = new Communit2.Models.User data
      userView = new Communit2.Views.Users model: user
      $('#new-followers-container').append userView.render().$el