class Dossier < ActiveRecord::Base
  attr_accessible :tagline, :user_id
  belongs_to :user
  has_many :dossier_statuses
  has_many :dossier_comments

  def add_status(status_text)
  	self.dossier_statuses.build(status: status_text)
  	self.save
  end

  def self.sort_by(column = :date, direction = "ASC")
    column ||= :date # because sometimes we send in nil (eg, dossiers#index)
    case column.to_sym
    when :user
      self.joins(:user).order("users.name #{direction}")
    when :date
      self.order("created_at #{direction}")
      # extend in future to sort by more stuff
    else
      self.order("#{column} #{direction}")
    end
  end

  def self.filter_by(status)
    self.joins(:dossier_statuses).where(:dossier_statuses => {:status => status})
  end

  def self.most_recent
    self.sort_by(:date, "DESC").limit(1)#.first
  end

  def last_status
    self.dossier_statuses.last
  end

end
