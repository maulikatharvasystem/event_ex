require 'rails_helper'

RSpec.describe GroupEvent, type: :model do

  let(:draft_group_event) { GroupEvent.new(user_id: 1,name: "Demo Project Event") }
  let(:published_group_event) { GroupEvent.new(user_id: 1,start_at: 1.week.from_now,duration: 30, location: "New York", description: "description goes here",name: "Demo Project Event" ) }
 
  it "must be valid when status is draft" do
  	expect(draft_group_event.status).to eq GroupEvent::STATUSES[:draft]
  	expect(draft_group_event.valid?).to eq true
  end

  it "must be valid when status is published" do
  	published_group_event.status = GroupEvent::STATUSES[:published]
  	expect(published_group_event.status).to eq GroupEvent::STATUSES[:published]
  	expect(published_group_event.valid?).to eq true
  end

  it "must be invalid when status is published and with limited data, " do  	
  	draft_group_event.status = GroupEvent::STATUSES[:published]
  	expect(draft_group_event.status).to eq GroupEvent::STATUSES[:published]
  	expect(draft_group_event.valid?).to eq false    
  end

  it 'should be delete status when event deleted' do
	  published_group_event.status = GroupEvent::STATUSES[:published]
	  published_group_event.save
	  expect(published_group_event.status).to eq GroupEvent::STATUSES[:published]

    published_group_event.status = GroupEvent::STATUSES[:deleted]
    expect(published_group_event.valid?).to eq true
    published_group_event.save

    published_group_event.reload
    expect(published_group_event.status).to eq GroupEvent::STATUSES[:deleted]    
	end

  it 'must be valid end_at when start_at and duration passed' do
    published_group_event.status = GroupEvent::STATUSES[:published]
    published_group_event.save
    
    expect(published_group_event.end_at).to eq(published_group_event.start_at + published_group_event.duration.days)
  end

  it 'must be nil end_at when start_at or duration blank' do
    expect(draft_group_event.end_at).to eq(nil)
    draft_group_event.start_at = Time.now.to_date
    draft_group_event.save
    
    expect(draft_group_event.end_at).to eq(nil)
    
    draft_group_event.start_at = nil
    draft_group_event.duration = 30
    draft_group_event.save
    
    expect(draft_group_event.end_at).to eq(nil)
  end 

end