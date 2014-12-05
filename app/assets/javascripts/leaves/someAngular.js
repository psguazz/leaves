var Leaves = angular.module('leaves', []);

Leaves.controller('searchController', function ($scope, $http) {
  $scope.taxonomy = null;
  $scope.taxonomyList = [];
  $scope.searchFields = [];
  $scope.searchResults = [];
  $scope.query = "";

  $http.get('search/taxonomies').then(function (taxonomies) {
    $scope.taxonomy = _.keys(taxonomies.data)[0];
    $scope.taxonomyList = taxonomies.data;
  });

  $scope.updateFields = function () {
    $scope.searchFields = $.unique($.trim($scope.query).split(' '));
  };

  $scope.search = function () {
    $scope.updateFields();

    $http.post('search/fetch', {
      taxonomy: $scope.taxonomy,
      fields: $scope.searchFields
    }).then(function (results) {
      $scope.searchResults = results.data;
    });
  };
});
