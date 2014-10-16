require 'net/http'
require 'uri'
require 'json'

class SearchController < ApplicationController
  @@sparql_uri = URI.parse(CONFIG['sparql_server'] + 'select?output=json')

  def fields
    query = 'PREFIX foo: <' + CONFIG['ontology_prefix'] + '#>
             SELECT DISTINCT ?s ?p ?o
             WHERE {
               ?s a foo:CompositionTaxonomyTag ;
                  ?p ?o .
             }'

    render json: get_results(query)
  end

  def fetch
    render json: params[:fields]
  end

  def get_results(query)
    response = Net::HTTP.post_form(@@sparql_uri, 'query' => query)
    data = JSON.parse(response.body)['results']['bindings']
    parse_results(data)
  end

  def parse_results(json_triples)
    results = {}

    json_triples.each do |triple|
      results[triple['s']['value']] = results[triple['s']['value']] || {}
      results[triple['s']['value']][triple['p']['value']] = results[triple['s']['value']][triple['p']['value']] || []
      results[triple['s']['value']][triple['p']['value']] += [triple['o']['value']]
    end

    results
  end
end
