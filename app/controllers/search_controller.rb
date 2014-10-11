require 'net/http'
require 'uri'
require 'json'

class SearchController < ApplicationController
  def fields
    uri = URI.parse(CONFIG['sparql_server'] + 'select?output=json')

    query = 'PREFIX foo: <' + CONFIG['ontology_prefix'] + '#>
             SELECT DISTINCT ?s ?p ?o
             WHERE {
               ?s a foo:CompositionTaxonomyTag ;
                  ?p ?o .
             } '

    response = Net::HTTP.post_form(uri, 'query' => query)

    render json: parse_results(response.body)
  end

  def get_things
    render json: params[:fields]
  end

  def parse_results(data)
    data = JSON.parse(data)['results']['bindings']
    results = {}

    data.each do |triple|
      results[triple['s']['value']] = results[triple['s']['value']] || {}
      results[triple['s']['value']][triple['p']['value']] = results[triple['s']['value']][triple['p']['value']] || []
      results[triple['s']['value']][triple['p']['value']] += [triple['o']['value']]
    end

    results
  end
end
