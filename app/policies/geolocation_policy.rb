class GeolocationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # here we are able to implement difficult logic that defines authorization permissions for each user
  def index? = true
  def show? = index?
  def create? = index?
  def destroy? = index?

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # here we are able to implement difficult logic that defines policy scope of records for each user
    def resolve = scope.all

    private

    attr_reader :user, :scope
  end
end