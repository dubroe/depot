class User < ActiveRecord::Base
  after_destroy :ensure_an_admin_remains #Called in the same transaction as delete. So will roll back if exception.
  validates :name, presence: true, uniqueness: true
  has_secure_password
  
  def self.authenticate(name, password)
    user = User.find_by_name(name)
    if user and user.authenticate(password)
      user
    else
      nil
    end
  end
  
  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end
end
