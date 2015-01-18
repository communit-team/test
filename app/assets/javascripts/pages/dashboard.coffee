class Communit2.Pages.Dashboard

  @initialize: ->
    @get_new_follower(1)
    @get_new_follower(2)
    @get_new_follower(3)

  @get_new_follower: (index) ->
    $.ajax(
      url: "users/new_follower"
      data: {index: index}
    ).done( (response) ->
      if response
        user = new Communit2.Models.User response
        userView = new Communit2.Views.Users model: user
        $('#new-followers-container').append userView.render().$el
    )