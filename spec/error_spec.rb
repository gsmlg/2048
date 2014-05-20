require File.expand_path("../spec_helper", __FILE__)

describe SinatraWebsocket::Error::StandardError do
  it "should be tagged with SinatraWebsocket::Error" do
    subject.should be_a SinatraWebsocket::Error
  end
end

describe SinatraWebsocket::Error::ConfigurationError do
  it "should be tagged with SinatraWebsocket::Error" do
    subject.should be_a SinatraWebsocket::Error
  end
end

describe SinatraWebsocket::Error::ConnectionError do
  it "should be tagged with SinatraWebsocket::Error" do
    subject.should be_a SinatraWebsocket::Error
  end
end

describe "Sinatra::Request" do
  context "the request is not a websocket request" do
    subject { Sinatra::Request.new({})}
    describe "#websocket?" do
      it { subject.websocket?.should be_nil }
    end
    describe "#websocket" do
      it do
        expect {
          subject.websocket
        }.to raise_error(SinatraWebsocket::Error::ConnectionError)
      end
    end
  end
end

describe "Sinatra::Websoket::Connection" do
  context "the request does not have an async callback" do
    describe ".from_env" do
      it "should raise SinatraWebsocket::Error::ConfigurationError" do
        expect {
          SinatraWebsocket::Connection.from_env({})
        }.to raise_error(SinatraWebsocket::Error::ConfigurationError)
      end
    end
  end
end
