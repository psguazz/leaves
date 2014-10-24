var Leaves = angular.module('leaves', []);

Leaves.controller('searchController', function ($scope, $http) {
  $scope.taxonomy = null;
  $scope.taxonomyList = [];
  $scope.searchFields = [];
  $scope.searchResults = [];

  $http.get('search/taxonomies').then(function (taxonomies) {
    $scope.taxonomy = _.keys(taxonomies.data)[0];
    $scope.taxonomyList = taxonomies.data;
    $scope.loadFields();
  });

  $scope.loadFields = function () {
    $http.post('search/fields', {taxonomy: $scope.taxonomy}).then(function (newFields) {
      $scope.searchFields = newFields.data;
    });
  };

  $scope.search = function () {
    var fields = _.map($scope.searchFields, function (f) {
      return { name: f.name, value: f.value};
    });

    $http.post('search/fetch', {fields: fields}).then(function (results) {
      $scope.searchResults = results.data;
    });
  };
});
