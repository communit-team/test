class Communit2.Views.Users extends Backbone.View
  newFollowerTemplate: JST['users/new_follower']
  newUnfollowerTemplate: JST['users/new_unfollower']

  render: (container) ->
    if container == '#new-followers-container'
      @$el.html @newFollowerTemplate(@model.toJSON())
      return @

    if container == '#new-unfollowers-container'
      @$el.html @newUnfollowerTemplate(@model.toJSON())
      return @


