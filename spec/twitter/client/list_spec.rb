require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".list_create" do

    before do
      stub_post("/1/lists/create.json").
        with(:body => {:name => "presidents"}).
        to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.list_create("presidents")
      a_post("/1/lists/create.json").
        with(:body => {:name => "presidents"}).
        should have_been_made
    end

    it "should return the created list" do
      list = @client.list_create("presidents")
      list.should be_a Twitter::List
      list.name.should == "presidents"
    end

  end

  describe ".list_update" do

    context "with screen name passed" do

      before do
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
          should have_been_made
      end

      it "should return the updated list" do
        list = @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "without screen name passed" do
      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          should have_been_made
      end
    end

    context "with an Integer list_id passed" do

      before do
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_update("sferik", 12345678, :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
          should have_been_made
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_post("/1/lists/update.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_update(12345678, 'presidents', :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_id => '12345678', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          should have_been_made
      end

    end
  end

  describe ".lists" do

    context "with a screen name passed" do

      before do
        stub_get("/1/lists.json").
          with(:query => {:screen_name => 'sferik', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.lists("sferik")
        a_get("/1/lists.json").
          with(:query => {:screen_name => 'sferik', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the updated list" do
        lists = @client.lists("sferik")
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_a Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "with an Integer user id passed" do

      before do
        stub_get("/1/lists.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.lists(12345678)
        a_get("/1/lists.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the updated list" do
        lists = @client.lists(12345678)
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_a Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "without arguments passed" do

      before do
        stub_get("/1/lists.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.lists
        a_get("/1/lists.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end

      it "should return the updated list" do
        lists = @client.lists
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_a Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

  end

  describe ".list" do

    context "with a screen name passed" do

      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list("sferik", "presidents")
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the updated list" do
        list = @client.list("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "without a screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list("sferik", "presidents")
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list("sferik", 12345678)
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list(12345678, 'presidents')
        a_get("/1/lists/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end

    end

  end

  describe ".list_destroy" do

    context "with a screen name passed" do

      before do
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_destroy("sferik", "presidents")
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the deleted list" do
        list = @client.list_destroy("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should == "presidents"
      end

    end

    context "without a screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_destroy("sferik", "presidents")
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_destroy("sferik", 12345678)
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_destroy(12345678, 'presidents')
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end

    end

  end

  describe ".list_timeline" do

    context "with a screen name passed" do

      before do
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_timeline("sferik", "presidents")
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the tweet timeline for members of the specified list" do
        statuses = @client.list_timeline("sferik", "presidents")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should == "Ruby is the best programming language for hiding the ugly bits."
      end

    end

    context "without a screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('sferik')
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_timeline("sferik", "presidents")
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end

      it "should return the tweet timeline for members of the specified list" do
        statuses = @client.list_timeline("sferik", "presidents")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should == "Ruby is the best programming language for hiding the ugly bits."
      end

    end

    context "with an Integer list_id passed" do

      before do
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_timeline("sferik", 12345678)
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.list_timeline(12345678, 'presidents')
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end

    end

  end

  describe ".memberships" do

    context "with a screen name passed" do

      before do
        stub_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.memberships("pengwynn")
        a_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the lists the specified user has been added to" do
        lists = @client.memberships("pengwynn")
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_an Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "without a screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('pengwynn')
        stub_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.memberships("pengwynn")
        a_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the lists the specified user has been added to" do
        lists = @client.memberships("pengwynn")
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_an Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_get("/1/lists/memberships.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.memberships(12345678)
        a_get("/1/lists/memberships.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          should have_been_made
      end

    end

  end

  describe ".subscriptions" do

    context "with a screen name passed" do

      before do
        stub_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.subscriptions("pengwynn")
        a_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the lists the specified user follows" do
        lists = @client.subscriptions("pengwynn")
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_an Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "without a screen name passed" do

      before do
        @client.stub!(:get_screen_name).and_return('pengwynn')
        stub_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.subscriptions("pengwynn")
        a_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end

      it "should return the lists the specified user follows" do
        lists = @client.subscriptions("pengwynn")
        lists.should be_a Hash
        lists['lists'].should be_an Array
        lists['lists'].first.should be_an Twitter::List
        lists['lists'].first.name.should == "Rubyists"
      end

    end

    context "with an Integer user_id passed" do

      before do
        stub_get("/1/lists/subscriptions.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.subscriptions(12345678)
        a_get("/1/lists/subscriptions.json").
          with(:query => {:user_id => '12345678', :cursor => "-1"}).
          should have_been_made
      end
    end
  end
end
