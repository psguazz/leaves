class SearchController < ApplicationController
  def fields
    render json: [{ 'name' => 'First', 'value' => '' }, { 'name' => 'Second', 'value' => '' }, { 'name' => 'Third', 'value' => '' }, { 'name' => 'Fourth', 'value' => '' }]
  end
end
