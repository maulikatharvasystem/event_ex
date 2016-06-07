class GroupEvent < ActiveRecord::Base
  STATUSES = {
    deleted: 0,
    draft: 1,
    published: 2,
    completed: 3
  }

  attr_accessor :is_published

  validates :user_id , presence: true
  validates :name, presence: true, :if => Proc.new{ |f| f.is_published? }
  validates :description , presence: true, :if => Proc.new{ |f| f.is_published? }
  validates :start_at , presence: true, :if => Proc.new{ |f| f.is_published? }
  validates :duration , presence: true, :if => Proc.new{ |f| f.is_published? }
  validates :location , presence: true, :if => Proc.new{ |f| f.is_published? }

  validate :validate_times

  def attributes
    super.merge(end_at: end_at)
  end

  def end_at
    return nil if self.start_at.nil? or self.duration.nil?
    (self.start_at + self.duration.days)
  end

  def after_initialize
  	self.status = STATUSES[:draft] if self.status.nil?
  end

  def set_status
    if self.is_published == 'true' or self.is_published == true
      self.status = STATUSES[:published]
    end
    self.status = STATUSES[:draft] if self.status.nil?
  end

  def validate_times
    if self.new_record? && (self.start_at && self.start_at < Time.now.to_date)
      self.errors.add(:start_at,"must be today or greater than today")
      return false
    end
    if self.duration && self.duration < 1
      self.errors.add(:duration,"must be greater than 1 day")
      return false
    end
  end

  protected

  def is_published?
  	return (self.status == STATUSES[:published])
  end
end
