/*
 * Do not edit this file manually.
 * This file is generated by "build/build-data-api".
 */
(function(window) {


window.MT.DataAPI.prototype.authorization = function() {
    var args = Array.prototype.slice.call(arguments, 0);
    return this.request.apply(this, [
        'GET',
        '/authorization'
    ].concat(args));
}

window.MT.DataAPI.prototype.authentication = function() {
    var args = Array.prototype.slice.call(arguments, 0);
    return this.request.apply(this, [
        'POST',
        '/authentication'
    ].concat(args));
}

window.MT.DataAPI.prototype.token = function() {
    var args = Array.prototype.slice.call(arguments, 0);
    return this.request.apply(this, [
        'GET',
        '/token'
    ].concat(args));
}

window.MT.DataAPI.prototype.getUser = function(user_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/users/:user_id', {
            user_id: user_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.updateUser = function(user_id, user) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'PUT',
        this.bindEndpointParams('/users/:user_id', {
            user_id: user_id
        })
    ].concat(args).concat([
        {
            user: user
        }
    ]));
}

window.MT.DataAPI.prototype.listBlogs = function(user_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/users/:user_id/sites', {
            user_id: user_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.getBlog = function(blog_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:blog_id', {
            blog_id: blog_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listEntries = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/entries', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.createEntry = function(site_id, entry) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'POST',
        this.bindEndpointParams('/sites/:site_id/entries', {
            site_id: site_id
        })
    ].concat(args).concat([
        {
            entry: entry
        }
    ]));
}

window.MT.DataAPI.prototype.getEntry = function(site_id, entry_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.updateEntry = function(site_id, entry_id, entry) {
    var args = Array.prototype.slice.call(arguments, 3);
    return this.request.apply(this, [
        'PUT',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args).concat([
        {
            entry: entry
        }
    ]));
}

window.MT.DataAPI.prototype.deleteEntry = function(site_id, entry_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'DELETE',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listCategories = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/categories', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listComments = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/comments', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listCommentsForEntries = function(site_id, entry_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id/comments', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.createComment = function(site_id, entry_id, comment) {
    var args = Array.prototype.slice.call(arguments, 3);
    return this.request.apply(this, [
        'POST',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id/comments', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args).concat([
        {
            comment: comment
        }
    ]));
}

window.MT.DataAPI.prototype.createReplyComment = function(site_id, entry_id, comment_id, comment) {
    var args = Array.prototype.slice.call(arguments, 4);
    return this.request.apply(this, [
        'POST',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id/comments/:comment_id/replies', {
            site_id: site_id,
            entry_id: entry_id,
            comment_id: comment_id
        })
    ].concat(args).concat([
        {
            comment: comment
        }
    ]));
}

window.MT.DataAPI.prototype.getComment = function(site_id, comment_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/comments/:comment_id', {
            site_id: site_id,
            comment_id: comment_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.updateComment = function(site_id, comment_id, comment) {
    var args = Array.prototype.slice.call(arguments, 3);
    return this.request.apply(this, [
        'PUT',
        this.bindEndpointParams('/sites/:site_id/comments/:comment_id', {
            site_id: site_id,
            comment_id: comment_id
        })
    ].concat(args).concat([
        {
            comment: comment
        }
    ]));
}

window.MT.DataAPI.prototype.deleteComment = function(site_id, comment_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'DELETE',
        this.bindEndpointParams('/sites/:site_id/comments/:comment_id', {
            site_id: site_id,
            comment_id: comment_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listTrackbacks = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/trackbacks', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.listTrackbacksForEntries = function(site_id, entry_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/entries/:entry_id/trackbacks', {
            site_id: site_id,
            entry_id: entry_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.getTrackback = function(site_id, ping_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/trackbacks/:ping_id', {
            site_id: site_id,
            ping_id: ping_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.updateTrackback = function(site_id, ping_id, trackback) {
    var args = Array.prototype.slice.call(arguments, 3);
    return this.request.apply(this, [
        'PUT',
        this.bindEndpointParams('/sites/:site_id/trackbacks/:ping_id', {
            site_id: site_id,
            ping_id: ping_id
        })
    ].concat(args).concat([
        {
            trackback: trackback
        }
    ]));
}

window.MT.DataAPI.prototype.deleteTrackback = function(site_id, ping_id) {
    var args = Array.prototype.slice.call(arguments, 2);
    return this.request.apply(this, [
        'DELETE',
        this.bindEndpointParams('/sites/:site_id/trackbacks/:ping_id', {
            site_id: site_id,
            ping_id: ping_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.statsProvider = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/stats/provider', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.statsPageviewsForPath = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/stats/path/pageviews', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.statsVisitsForPath = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/stats/path/visits', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.statsPageviewsForDate = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/stats/date/pageviews', {
            site_id: site_id
        })
    ].concat(args));
}

window.MT.DataAPI.prototype.statsVisitsForDate = function(site_id) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.request.apply(this, [
        'GET',
        this.bindEndpointParams('/sites/:site_id/stats/date/visits', {
            site_id: site_id
        })
    ].concat(args));
}


})(window);
