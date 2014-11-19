require 'spec_helper'

RSpec.describe PagesController do
  let(:site) { page.site }
  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end

  describe 'GET /pages' do
    let(:page) { create(:page) }

    context 'when searching pages' do
      before do
        get :index, site_id: site.id, search: page.label
      end

      it 'assigns filters variable' do
        expect(assigns[:filters_present]).to be_truthy
      end

      it 'assigns pages using the comfy search' do
        expect(assigns[:pages]).to match_array([page])
      end
    end

    context 'when filtering pages' do
      let(:page) do
        create(:page,
          label: 'test1',
          slug:   'test1',
          parent: create(:child_page)
        )
      end

      let!(:another_page) do
        create(:page,
          site:   page.site,
          label:  'test2',
          slug:   'test2',
          parent: create(:child_page),
          layout: create(:layout, :nested)
        )
      end

      before do
        get :index, site_id: site.id, layout: :nested
      end

      it 'does not assign filters variable' do
        expect(assigns[:filters_present]).to be_falsy
      end

      it 'assigns pages filtering the results' do
        expect(assigns[:pages]).to match_array([another_page])
      end
    end
  end

  describe 'POST /pages' do
    let(:site)   { create(:site) }
    let(:layout) { create(:layout) }

    context 'when pass the state event "save_unsaved"' do
      before do
        post :create,
          site_id:      site.id,
          state_event:  'save_unsaved',
          page: {
            label:     'Test Page',
            slug:      'test-page',
            layout_id: layout.id
          }
      end

      it 'creates a page with draft as state event' do
        expect(assigns[:page].state).to eq 'draft'
      end

      context 'creates revision' do
        subject(:last_revision) { assigns[:page].revisions.last }
        before do
          assigns[:page].revisions.reload
          expect(last_revision).to_not be nil
        end

        it 'saves the previous event state in the last revision' do
          expect(last_revision.data[:event]).to eq(
            from: nil,
            to:   'draft'
          )
        end

        it 'saves the current user in the last revision' do
          expect(last_revision.data[:author]).to eq(
            id:   current_user.id,
            name: current_user.name
          )
        end
      end
    end

    context 'when passes the state event "publish"' do
      before do
        post :create,
          site_id:      site.id,
          state_event:  'publish',
          page: {
            label:     'Test Page',
            slug:      'test-page',
            layout_id: layout.id
          }
      end

      it 'ignores the state event and persists as "unsaved"' do
        expect(assigns[:page].state).to eq 'unsaved'
      end
    end

    context 'when does not pass the state event' do
      before do
        post :create,
          site_id:      site.id,
          page: {
            label:     'Test Page',
            slug:      'test-page',
            layout_id: layout.id
          }
      end

      it 'persists page as "unsaved"' do
        expect(assigns[:page].state).to eq 'unsaved'
      end

      it 'does not save any revision' do
        expect(assigns[:page].revisions).to eq []
      end
    end
  end

  describe 'PUT /pages/:id' do
    before do
      put :update,
        site_id:     site.id,
        id:          page.id,
        state_event: state_event,
        page: {
          label: 'Another label',
          slug:  'another-slug'
        }
    end

    context 'when passes the "save_unsaved" event state from an "unsaved" page' do
      let!(:page) { create(:page, state: 'unsaved') }
      let(:state_event) { 'save_unsaved' }

      it 'persists page as "draft"' do
        expect(assigns[:page].state).to eq 'draft'
      end
    end

    context 'when passes the same event state from the page' do
      let!(:page) { create(:page, state: 'published') }
      let(:state_event) { 'publish' }

      it 'does not save any revisions' do
        expect(assigns[:page].revisions).to eq []
      end
    end

    context 'when passes the "publish" event state' do
      let!(:page) { create(:page, state: 'draft') }
      let(:state_event) { 'publish'}

      it 'persists page as "published"' do
        expect(assigns[:page].state).to eq 'published'
      end

      context 'creates revision' do
        subject(:last_revision) { assigns[:page].revisions.last }
        before do
          assigns[:page].revisions.reload
          expect(last_revision).to_not be nil
        end

        it 'saves the previous event state in the last revision' do
          expect(last_revision.data[:event]).to eq(
            from: 'draft',
            to:   'published'
          )
        end

        it 'saves the current user in the last revision' do
          expect(last_revision.data[:author]).to eq(
            id:   current_user.id,
            name: current_user.name
          )
        end
      end
    end

    context 'when does not pass any event state' do
      let!(:page) { create(:page, state: 'draft') }
      let(:state_event) { nil }

      it 'persists page attributes' do
        expect(assigns[:page].attributes.symbolize_keys).to include({
          label: 'Another label',
          slug:  'another-slug'
        })
      end

      it 'does not save any revisions' do
        expect(assigns[:page].revisions).to eq []
      end
    end
  end
end
