require 'rails_helper'

module Ecm
  module Cms
    describe Template do
      subject { FactoryGirl.create :ecm_cms_template }

      context 'associations' do
        it { should belong_to :ecm_cms_folder }
      end

      context 'callbacks' do
        subject { Ecm::Cms::Template.new }

        it "adds a '/' to the pathname before validation" do
          subject.pathname = 'bar'
          subject.save
          subject.pathname.should eq('bar/')
        end

        context 'sets default handler on initialization' do
          it { expect(subject.handler).to eq(Ecm::Cms::Configuration.default_handlers[:page].to_s) }
        end

        context 'sets default locale on initialization' do
          before(:each) { I18n.locale = :de }
          it { expect(subject.locale).to eq(I18n.locale.to_s) }
        end
      end

      context 'template callbacks' do
        subject { Ecm::Cms::Template.new }

        it "removes a '_' from the basename before validation" do
          subject.basename = '_foo'
          subject.valid?

          subject.basename.should eq('foo')
        end
      end

      context 'validations' do
        it { should validate_presence_of :basename }
        # Removed test to respect adding a trailing slash to pathname before validation
        # if pathname is blank
        # it { should validate_presence_of :pathname }
        it { should validate_uniqueness_of(:basename).scoped_to([:pathname, :locale, :format, :handler]) }

        it { should validate_inclusion_of(:format).in_array(Mime::SET.symbols.map(&:to_s)) }
        it { should_not allow_value('foo').for(:format) }

        it { should validate_inclusion_of(:handler).in_array(ActionView::Template::Handlers.extensions.map(&:to_s)) }
        it { should_not allow_value('foo').for(:handler) }

        it { should validate_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
        it { should_not allow_value('foo').for(:locale) }

        # TODO: Validate that basename does not begin with an underscore
      end

      context '#filename' do
        subject { Ecm::Cms::Template.new }

        it 'builds foo.html from basename => foo, handler => html' do
          subject.basename = 'foo'
          subject.locale   = nil
          subject.handler  = 'html'

          subject.filename.should eq('foo.html')
        end

        it 'builds foo.en.html from basename => foo, locale => en, handler => html' do
          subject.basename = 'foo'
          subject.locale   = 'en'
          subject.handler  = 'html'

          subject.filename.should eq('foo.en.html')
        end
      end
    end
  end
end
