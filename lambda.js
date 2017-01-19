/*
return episodes or friend recommendations from neo4j
*/
"use strict";
/// <reference path="../typings/index.d.ts" />
var sdk = require('aws-sdk');

function recommendFriend(email, method, callback) {
    var httpRequestError = {
        code: "500",
        message: "Can't connect neo4j"

    };
    var internalServerError = {
        code: "500",
        message: "neo4j can't connect"

    };
    /*calling neo4j */
    var request = require('request');
    var httpUrlForTransaction = "my url"
    function runCypherQuery(query, params, callback) {
        request.post({
            uri: httpUrlForTransaction,
            json: { statements: [{ statement: query, parameters: params }] }
        },
            function (err, res, body) {
                callback(err, body);
            })
    }

    /**
     * Let’s fire some queries
     * */
    var query = ""
    if (method === 'episode'){
        query = "MATCH (me:user {email:{email}})-[myrating:RATE]->(myratedepisode:content)\nMATCH (other:user)-[theirrating:RATE]->(myratedepisode)\nWHERE me <> other\nAND abs(myrating.score - theirrating.score) < 2\nWITH other, myratedepisode\nMATCH (other)-[otherrating:RATE]->(episode:content)\nWHERE myratedepisode <> episode\nWITH avg(otherrating.score) AS avgRating, episode\nRETURN episode\nORDER BY avgRating desc\nLIMIT 3"
    } else if (method === 'friend') {
        query = "MATCH  (me:user)-[:FRIEND]-(myFriend:user)-[:FRIEND]-(friendOfFriend:user) \nMATCH (me:user) -[:LIKE] -> (episode:content)\nMATCH (friendOfFriend) - [:LIKE] -> (episode)\nWITH friendOfFriend, count(episode) as nOfCommonLikes, collect(episode) as episodes, me\nWHERE NOT (me)-[:FRIEND]-(friendOfFriend:Person) AND me.email = {email} AND nOfCommonLikes >= 1\nRETURN friendOfFriend as suggestedFriend;"
    }

    runCypherQuery(
       query, {
            email: email,
        }, function (err, resp) {
            if (err) {
                console.log(err);
            } else {
                var episodes = "";
                episodes = resp["results"][0]["data"].map(function(x){return x["row"][0]})
                callback(null, episodes);

            }
        }
    );
}

function handler(event, context, callback) {

    switch (event.operation) {
        case 'getRecommendation':
            var email = event.payload.item.email;
            var method = event.payload.item.method;
            recommendFriend(email, method, callback)
            break;

    }
}
exports.handler = handler;
