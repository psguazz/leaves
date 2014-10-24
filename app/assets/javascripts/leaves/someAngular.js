var Leaves = angular.module('leaves', []);

Leaves.controller('searchController', function ($scope, $http) {
  $scope.searchResults = [];
  $scope.taxonomies = [];
  $scope.searchFields = [];

  $http.get('search/taxonomies').then(function (taxonomies) {
    $scope.taxonomies = taxonomies.data;
  });

  $scope.search = function () {
    var fields = _.map($scope.searchFields, function (f) {
      return { name: f.name, value: f.value};
    });

    $http.post('search/fetch', {fields: fields}).then(function (results) {
      $scope.searchResults = results.data;
    });
  };
});
