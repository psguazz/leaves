require 'net/http'
require 'uri'
require 'json'

class SearchController < ApplicationController
  @@sparql_uri = URI.parse(CONFIG['sparql_server'] + 'select?output=json')

  def taxonomies
    where = ['?s rdf:type leaves:CompositionTaxonomy',
             '?s skos:prefLabel ?o']

    query = build_query(where, {:p => '("Label" AS ?p)'})
    render json: get_results(query)
  end

  def fields
    taxonomy = params[:taxonomy]

    where = ["?t leaves:MemberOfTaxonomy <#{taxonomy}>",
             '?t ?s ?v',
             '?s skos:prefLabel ?o']

    query = build_query(where, {:p => '("Label" AS ?p)'})
    render json: get_results(query)
  end

  def fetch
    return render json: [] if params[:fields] == nil
    taxonomy = params[:taxonomy]
    fields = params[:fields]

    where = fields.map { |f| '?s <%s> "%s"' % [f['field'], f['value']] }
    where += ["?s leaves:MemberOfCompositionTaxonomy <#{taxonomy}>"]
    where += ['?s ?p ?o']

    query = build_query(where)
    render json: get_results(query)
  end

  def build_query(where, vars={})
    s, p, o = (vars[:s] || '?s'), (vars[:p] || '?p'), (vars[:o] || '?o')

    "PREFIX leaves: <" + CONFIG['leaves_prefix'] + "#>
     PREFIX skos: <" + CONFIG['skos_prefix'] + "#>
     SELECT #{s} #{p} #{o} WHERE { " + where.join(' . ') + " }"
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
