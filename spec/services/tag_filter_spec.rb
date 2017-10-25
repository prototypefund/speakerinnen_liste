describe TagFilter do
  subject(:tag_filter) { described_class.new(ActsAsTaggableOn::Tag.all, filter_params).filter }

  let!(:tag_1) { ActsAsTaggableOn::Tag.create!(id: 1, name: 'social media') }
  let!(:tag_2) { ActsAsTaggableOn::Tag.create!(id: 2, name: 'ruby') }
  let!(:tag_3) { ActsAsTaggableOn::Tag.create!(id: 3, name: 'entertainment') }
  let!(:tag_4) { ActsAsTaggableOn::Tag.create!(id: 4, name: 'Soziale Medien') }

  let!(:category_1) { Category.create!(id: 1, name: 'marketing & pr', tags: [tag_1, tag_4]) }
  let!(:category_2) { Category.create!(id: 2, name: 'development', tags: [tag_2]) }

  let!(:tag_language) { TagLanguage.create!(tag_id: 1, language: 'en') }
  let!(:tag_language_second) { TagLanguage.create!(tag_id: 1, language: 'de') }
  let!(:tag_language_third) { TagLanguage.create!(tag_id: 3, language: 'en') }
  let!(:tag_language_fourth) { TagLanguage.create!(tag_id: 4, language: 'de') }

  context 'with empty filter params' do
    let(:filter_params) { {} }
    it { is_expected.to match_array([tag_1, tag_2, tag_3, tag_4]) }
  end

  context 'with given but empty categories' do
    let(:filter_params) { { uncategorized: true } }
    it { is_expected.to match_array([tag_3]) }
  end

  context 'with a given category' do
    let(:filter_params) { { category_id: 1 } }
    it { is_expected.to match_array([tag_1, tag_4]) }
  end

  context 'with a given query' do
    let(:filter_params) { { q: 'ruby' } }
    it { is_expected.to match_array([tag_2]) }
  end

  context 'with empty category and given query' do
    let(:filter_params) { { uncategorized: true, q: 'entertainment' } }
    it { is_expected.to match_array([tag_3]) }
  end

  context 'with given but empty language params' do
    let(:filter_params) { { no_language: true } }
    it { is_expected.to match_array([tag_2]) }
  end

  context 'with given language params' do
    let(:filter_params) { { filter_languages: ['en'] } }
    it { is_expected.to match_array([tag_1, tag_3]) }
  end

  context 'with two given language params' do
    let(:filter_params) { { filter_languages: ['de', 'en'] } }
    it { is_expected.to match_array([tag_1]) }
  end

  context 'with given category and language params' do
    let(:filter_params) { { category_id: 1, filter_languages: ['en'] } }
    it { is_expected.to match_array([tag_1]) }
  end

  context 'with given category and empty language params' do
    let(:filter_params) { { category_id: 2, no_language: true } }
    it { is_expected.to match_array([tag_2]) }
  end
end