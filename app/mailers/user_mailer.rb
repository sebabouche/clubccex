class UserMailer < ApplicationMailer

  ### as user
  def welcome_unconfirmed(id)
    @user = User.find(id)
    mail(
      to: @user.email,
      subject: "[CCEx] Merci de t'être enregistré(e).")
  end

  def sign_up(id)
    @user = User.find(id)
    mail(
      to: @user.email,
      subject: "[CCEx] Rejoins le club business des anciens courseux.")
  end

  def wake_up(id)
    @user = User.find(id)
    @confirmation_token = Tyrant::Authenticatable.new(@user).confirmation_token
    mail(
      to: @user.email,
      subject: "[CCEx] Génial ! Tu es accepté(e) au Club CCEx.")
  end

  ### as recommnder
  def sign_up_recommender(recommender_id, user_id)
    find_users!(recommender_id, user_id)
    mail(
      to: @recommender.email,
      subject: "[CCEx] Rejoins les anciens courseux et confirme que #{user_name(@user)} en fait partie.")
  end

  def wake_up_reminder(recommender_id, user_id)
    find_users!(recommender_id, user_id)
    @confirmation_token = Tyrant::Authenticatable.new(@recommender).confirmation_token
    mail(
      to: @recommender.email,
      subject: "[CCEx] #{user_name(@user)} attend ta confirmation, rejoins-nous !")
  end

  def confirm_user(recommender_id, user_id)
    @recommendation = Recommendation.find_by_user_id_and_recommender_id!(user_id, recommender_id)
    mail(
      to: @recommendation.recommender.email,
      subject: "[CCEx] Confirmes-tu que #{user_name(@recommendation.user)} fait partie des anciens ?")
  end

  ### COMMENT
  def notify_comment(comment_id)
    @comment = Comment.find(comment_id)
    mail(
      to: @comment.post.user.email,
      subject: "[CCEx] #{@comment.user.firstname} #{@comment.user.lastname} a commenté un post que tu as écrit.")
  end

  private

  def find_users!(recommender_id, user_id)
    @recommender = User.find(recommender_id)
    @user = User.find(user_id)
  end

  def user_name(user)
    user.firstname + " " + user.lastname
  end
end

