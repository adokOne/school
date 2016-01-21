/**
 * Super simple wysiwyg editor v0.7.3
 * http://summernote.org/
 *
 * summernote.js
 * Copyright 2013-2015 Alan Hong. and other contributors
 * summernote may be freely distributed under the MIT license./
 *
 * Date: 2016-01-14T13:17Z
 */
(function (factory) {
  /* global define */
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['jquery'], factory);
  } else if (typeof module === 'object' && module.exports) {
    // Node/CommonJS
    module.exports = factory(require('jquery'));
  } else {
    // Browser globals
    factory(window.jQuery);
  }
}(function ($) {
  'use strict';

  /**
   * @class core.func
   *
   * func utils (for high-order func's arg)
   *
   * @singleton
   * @alternateClassName func
   */
  var func = (function () {
    var eq = function (itemA) {
      return function (itemB) {
        return itemA === itemB;
      };
    };

    var eq2 = function (itemA, itemB) {
      return itemA === itemB;
    };

    var peq2 = function (propName) {
      return function (itemA, itemB) {
        return itemA[propName] === itemB[propName];
      };
    };

    var ok = function () {
      return true;
    };

    var fail = function () {
      return false;
    };

    var not = function (f) {
      return function () {
        return !f.apply(f, arguments);
      };
    };

    var and = function (fA, fB) {
      return function (item) {
        return fA(item) && fB(item);
      };
    };

    var self = function (a) {
      return a;
    };

    var invoke = function (obj, method) {
      return function () {
        return obj[method].apply(obj, arguments);
      };
    };

    var idCounter = 0;

    /**
     * generate a globally-unique id
     *
     * @param {String} [prefix]
     */
    var uniqueId = function (prefix) {
      var id = ++idCounter + '';
      return prefix ? prefix + id : id;
    };

    /**
     * returns bnd (bounds) from rect
     *
     * - IE Compatability Issue: http://goo.gl/sRLOAo
     * - Scroll Issue: http://goo.gl/sNjUc
     *
     * @param {Rect} rect
     * @return {Object} bounds
     * @return {Number} bounds.top
     * @return {Number} bounds.left
     * @return {Number} bounds.width
     * @return {Number} bounds.height
     */
    var rect2bnd = function (rect) {
      var $document = $(document);
      return {
        top: rect.top + $document.scrollTop(),
        left: rect.left + $document.scrollLeft(),
        width: rect.right - rect.left,
        height: rect.bottom - rect.top
      };
    };

    /**
     * returns a copy of the object where the keys have become the values and the values the keys.
     * @param {Object} obj
     * @return {Object}
     */
    var invertObject = function (obj) {
      var inverted = {};
      for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
          inverted[obj[key]] = key;
        }
      }
      return inverted;
    };

    /**
     * @param {String} namespace
     * @param {String} [prefix]
     * @return {String}
     */
    var namespaceToCamel = function (namespace, prefix) {
      prefix = prefix || '';
      return prefix + namespace.split('.').map(function (name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1);
      }).join('');
    };

    return {
      eq: eq,
      eq2: eq2,
      peq2: peq2,
      ok: ok,
      fail: fail,
      self: self,
      not: not,
      and: and,
      invoke: invoke,
      uniqueId: uniqueId,
      rect2bnd: rect2bnd,
      invertObject: invertObject,
      namespaceToCamel: namespaceToCamel
    };
  })();

  /**
   * @class core.list
   *
   * list utils
   *
   * @singleton
   * @alternateClassName list
   */
  var list = (function () {
    /**
     * returns the first item of an array.
     *
     * @param {Array} array
     */
    var head = function (array) {
      return array[0];
    };

    /**
     * returns the last item of an array.
     *
     * @param {Array} array
     */
    var last = function (array) {
      return array[array.length - 1];
    };

    /**
     * returns everything but the last entry of the array.
     *
     * @param {Array} array
     */
    var initial = function (array) {
      return array.slice(0, array.length - 1);
    };

    /**
     * returns the rest of the items in an array.
     *
     * @param {Array} array
     */
    var tail = function (array) {
      return array.slice(1);
    };

    /**
     * returns item of array
     */
    var find = function (array, pred) {
      for (var idx = 0, len = array.length; idx < len; idx ++) {
        var item = array[idx];
        if (pred(item)) {
          return item;
        }
      }
    };

    /**
     * returns true if all of the values in the array pass the predicate truth test.
     */
    var all = function (array, pred) {
      for (var idx = 0, len = array.length; idx < len; idx ++) {
        if (!pred(array[idx])) {
          return false;
        }
      }
      return true;
    };

    /**
     * returns index of item
     */
    var indexOf = function (array, item) {
      return $.inArray(item, array);
    };

    /**
     * returns true if the value is present in the list.
     */
    var contains = function (array, item) {
      return indexOf(array, item) !== -1;
    };

    /**
     * get sum from a list
     *
     * @param {Array} array - array
     * @param {Function} fn - iterator
     */
    var sum = function (array, fn) {
      fn = fn || func.self;
      return array.reduce(function (memo, v) {
        return memo + fn(v);
      }, 0);
    };

    /**
     * returns a copy of the collection with array type.
     * @param {Collection} collection - collection eg) node.childNodes, ...
     */
    var from = function (collection) {
      var result = [], idx = -1, length = collection.length;
      while (++idx < length) {
        result[idx] = collection[idx];
      }
      return result;
    };

    /**
     * returns whether list is empty or not
     */
    var isEmpty = function (array) {
      return !array || !array.length;
    };

    /**
     * cluster elements by predicate function.
     *
     * @param {Array} array - array
     * @param {Function} fn - predicate function for cluster rule
     * @param {Array[]}
     */
    var clusterBy = function (array, fn) {
      if (!array.length) { return []; }
      var aTail = tail(array);
      return aTail.reduce(function (memo, v) {
        var aLast = last(memo);
        if (fn(last(aLast), v)) {
          aLast[aLast.length] = v;
        } else {
          memo[memo.length] = [v];
        }
        return memo;
      }, [[head(array)]]);
    };

    /**
     * returns a copy of the array with all falsy values removed
     *
     * @param {Array} array - array
     * @param {Function} fn - predicate function for cluster rule
     */
    var compact = function (array) {
      var aResult = [];
      for (var idx = 0, len = array.length; idx < len; idx ++) {
        if (array[idx]) { aResult.push(array[idx]); }
      }
      return aResult;
    };

    /**
     * produces a duplicate-free version of the array
     *
     * @param {Array} array
     */
    var unique = function (array) {
      var results = [];

      for (var idx = 0, len = array.length; idx < len; idx ++) {
        if (!contains(results, array[idx])) {
          results.push(array[idx]);
        }
      }

      return results;
    };

    /**
     * returns next item.
     * @param {Array} array
     */
    var next = function (array, item) {
      var idx = indexOf(array, item);
      if (idx === -1) { return null; }

      return array[idx + 1];
    };

    /**
     * returns prev item.
     * @param {Array} array
     */
    var prev = function (array, item) {
      var idx = indexOf(array, item);
      if (idx === -1) { return null; }

      return array[idx - 1];
    };

    return { head: head, last: last, initial: initial, tail: tail,
             prev: prev, next: next, find: find, contains: contains,
             all: all, sum: sum, from: from, isEmpty: isEmpty,
             clusterBy: clusterBy, compact: compact, unique: unique };
  })();

  var isSupportAmd = typeof define === 'function' && define.amd;

  /**
   * returns whether font is installed or not.
   *
   * @param {String} fontName
   * @return {Boolean}
   */
  var isFontInstalled = function (fontName) {
    var testFontName = fontName === 'Comic Sans MS' ? 'Courier New' : 'Comic Sans MS';
    var $tester = $('<div>').css({
      position: 'absolute',
      left: '-9999px',
      top: '-9999px',
      fontSize: '200px'
    }).text('mmmmmmmmmwwwwwww').appendTo(document.body);

    var originalWidth = $tester.css('fontFamily', testFontName).width();
    var width = $tester.css('fontFamily', fontName + ',' + testFontName).width();

    $tester.remove();

    return originalWidth !== width;
  };

  var userAgent = navigator.userAgent;
  var isMSIE = /MSIE|Trident/i.test(userAgent);
  var browserVersion;
  if (isMSIE) {
    var matches = /MSIE (\d+[.]\d+)/.exec(userAgent);
    if (matches) {
      browserVersion = parseFloat(matches[1]);
    }
    matches = /Trident\/.*rv:([0-9]{1,}[\.0-9]{0,})/.exec(userAgent);
    if (matches) {
      browserVersion = parseFloat(matches[1]);
    }
  }

  /**
   * @class core.agent
   *
   * Object which check platform and agent
   *
   * @singleton
   * @alternateClassName agent
   */
  var agent = {
    isMac: navigator.appVersion.indexOf('Mac') > -1,
    isMSIE: isMSIE,
    isFF: /firefox/i.test(userAgent),
    isWebkit: /webkit/i.test(userAgent),
    isSafari: /safari/i.test(userAgent),
    browserVersion: browserVersion,
    jqueryVersion: parseFloat($.fn.jquery),
    isSupportAmd: isSupportAmd,
    hasCodeMirror: isSupportAmd ? require.specified('codemirror') : !!window.CodeMirror,
    isFontInstalled: isFontInstalled,
    isW3CRangeSupport: !!document.createRange
  };


  var NBSP_CHAR = String.fromCharCode(160);
  var ZERO_WIDTH_NBSP_CHAR = '\ufeff';

  /**
   * @class core.dom
   *
   * Dom functions
   *
   * @singleton
   * @alternateClassName dom
   */
  var dom = (function () {
    /**
     * @method isEditable
     *
     * returns whether node is `note-editable` or not.
     *
     * @param {Node} node
     * @return {Boolean}
     */
    var isEditable = function (node) {
      return node && $(node).hasClass('note-editable');
    };

    /**
     * @method isControlSizing
     *
     * returns whether node is `note-control-sizing` or not.
     *
     * @param {Node} node
     * @return {Boolean}
     */
    var isControlSizing = function (node) {
      return node && $(node).hasClass('note-control-sizing');
    };

    /**
     * @method makePredByNodeName
     *
     * returns predicate which judge whether nodeName is same
     *
     * @param {String} nodeName
     * @return {Function}
     */
    var makePredByNodeName = function (nodeName) {
      nodeName = nodeName.toUpperCase();
      return function (node) {
        return node && node.nodeName.toUpperCase() === nodeName;
      };
    };

    /**
     * @method isText
     *
     *
     *
     * @param {Node} node
     * @return {Boolean} true if node's type is text(3)
     */
    var isText = function (node) {
      return node && node.nodeType === 3;
    };

    /**
     * @method isElement
     *
     *
     *
     * @param {Node} node
     * @return {Boolean} true if node's type is element(1)
     */
    var isElement = function (node) {
      return node && node.nodeType === 1;
    };

    /**
     * ex) br, col, embed, hr, img, input, ...
     * @see http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
     */
    var isVoid = function (node) {
      return node && /^BR|^IMG|^HR|^IFRAME|^BUTTON/.test(node.nodeName.toUpperCase());
    };

    var isPara = function (node) {
      if (isEditable(node)) {
        return false;
      }

      // Chrome(v31.0), FF(v25.0.1) use DIV for paragraph
      return node && /^DIV|^P|^LI|^H[1-7]/.test(node.nodeName.toUpperCase());
    };

    var isHeading = function (node) {
      return node && /^H[1-7]/.test(node.nodeName.toUpperCase());
    };

    var isPre = makePredByNodeName('PRE');

    var isLi = makePredByNodeName('LI');

    var isPurePara = function (node) {
      return isPara(node) && !isLi(node);
    };

    var isTable = makePredByNodeName('TABLE');

    var isInline = function (node) {
      return !isBodyContainer(node) &&
             !isList(node) &&
             !isHr(node) &&
             !isPara(node) &&
             !isTable(node) &&
             !isBlockquote(node);
    };

    var isList = function (node) {
      return node && /^UL|^OL/.test(node.nodeName.toUpperCase());
    };

    var isHr = makePredByNodeName('HR');

    var isCell = function (node) {
      return node && /^TD|^TH/.test(node.nodeName.toUpperCase());
    };

    var isBlockquote = makePredByNodeName('BLOCKQUOTE');

    var isBodyContainer = function (node) {
      return isCell(node) || isBlockquote(node) || isEditable(node);
    };

    var isAnchor = makePredByNodeName('A');

    var isParaInline = function (node) {
      return isInline(node) && !!ancestor(node, isPara);
    };

    var isBodyInline = function (node) {
      return isInline(node) && !ancestor(node, isPara);
    };

    var isBody = makePredByNodeName('BODY');

    /**
     * returns whether nodeB is closest sibling of nodeA
     *
     * @param {Node} nodeA
     * @param {Node} nodeB
     * @return {Boolean}
     */
    var isClosestSibling = function (nodeA, nodeB) {
      return nodeA.nextSibling === nodeB ||
             nodeA.previousSibling === nodeB;
    };

    /**
     * returns array of closest siblings with node
     *
     * @param {Node} node
     * @param {function} [pred] - predicate function
     * @return {Node[]}
     */
    var withClosestSiblings = function (node, pred) {
      pred = pred || func.ok;

      var siblings = [];
      if (node.previousSibling && pred(node.previousSibling)) {
        siblings.push(node.previousSibling);
      }
      siblings.push(node);
      if (node.nextSibling && pred(node.nextSibling)) {
        siblings.push(node.nextSibling);
      }
      return siblings;
    };

    /**
     * blank HTML for cursor position
     * - [workaround] old IE only works with &nbsp;
     * - [workaround] IE11 and other browser works with bogus br
     */
    var blankHTML = agent.isMSIE && agent.browserVersion < 11 ? '&nbsp;' : '<br>';

    /**
     * @method nodeLength
     *
     * returns #text's text size or element's childNodes size
     *
     * @param {Node} node
     */
    var nodeLength = function (node) {
      if (isText(node)) {
        return node.nodeValue.length;
      }

      return node.childNodes.length;
    };

    /**
     * returns whether node is empty or not.
     *
     * @param {Node} node
     * @return {Boolean}
     */
    var isEmpty = function (node) {
      var len = nodeLength(node);

      if (len === 0) {
        return true;
      } else if (!isText(node) && len === 1 && node.innerHTML === blankHTML) {
        // ex) <p><br></p>, <span><br></span>
        return true;
      } else if (list.all(node.childNodes, isText) && node.innerHTML === '') {
        // ex) <p></p>, <span></span>
        return true;
      }

      return false;
    };

    /**
     * padding blankHTML if node is empty (for cursor position)
     */
    var paddingBlankHTML = function (node) {
      if (!isVoid(node) && !nodeLength(node)) {
        node.innerHTML = blankHTML;
      }
    };

    /**
     * find nearest ancestor predicate hit
     *
     * @param {Node} node
     * @param {Function} pred - predicate function
     */
    var ancestor = function (node, pred) {
      while (node) {
        if (pred(node)) { return node; }
        if (isEditable(node)) { break; }

        node = node.parentNode;
      }
      return null;
    };

    /**
     * find nearest ancestor only single child blood line and predicate hit
     *
     * @param {Node} node
     * @param {Function} pred - predicate function
     */
    var singleChildAncestor = function (node, pred) {
      node = node.parentNode;

      while (node) {
        if (nodeLength(node) !== 1) { break; }
        if (pred(node)) { return node; }
        if (isEditable(node)) { break; }

        node = node.parentNode;
      }
      return null;
    };

    /**
     * returns new array of ancestor nodes (until predicate hit).
     *
     * @param {Node} node
     * @param {Function} [optional] pred - predicate function
     */
    var listAncestor = function (node, pred) {
      pred = pred || func.fail;

      var ancestors = [];
      ancestor(node, function (el) {
        if (!isEditable(el)) {
          ancestors.push(el);
        }

        return pred(el);
      });
      return ancestors;
    };

    /**
     * find farthest ancestor predicate hit
     */
    var lastAncestor = function (node, pred) {
      var ancestors = listAncestor(node);
      return list.last(ancestors.filter(pred));
    };

    /**
     * returns common ancestor node between two nodes.
     *
     * @param {Node} nodeA
     * @param {Node} nodeB
     */
    var commonAncestor = function (nodeA, nodeB) {
      var ancestors = listAncestor(nodeA);
      for (var n = nodeB; n; n = n.parentNode) {
        if ($.inArray(n, ancestors) > -1) { return n; }
      }
      return null; // difference document area
    };

    /**
     * listing all previous siblings (until predicate hit).
     *
     * @param {Node} node
     * @param {Function} [optional] pred - predicate function
     */
    var listPrev = function (node, pred) {
      pred = pred || func.fail;

      var nodes = [];
      while (node) {
        if (pred(node)) { break; }
        nodes.push(node);
        node = node.previousSibling;
      }
      return nodes;
    };

    /**
     * listing next siblings (until predicate hit).
     *
     * @param {Node} node
     * @param {Function} [pred] - predicate function
     */
    var listNext = function (node, pred) {
      pred = pred || func.fail;

      var nodes = [];
      while (node) {
        if (pred(node)) { break; }
        nodes.push(node);
        node = node.nextSibling;
      }
      return nodes;
    };

    /**
     * listing descendant nodes
     *
     * @param {Node} node
     * @param {Function} [pred] - predicate function
     */
    var listDescendant = function (node, pred) {
      var descendents = [];
      pred = pred || func.ok;

      // start DFS(depth first search) with node
      (function fnWalk(current) {
        if (node !== current && pred(current)) {
          descendents.push(current);
        }
        for (var idx = 0, len = current.childNodes.length; idx < len; idx++) {
          fnWalk(current.childNodes[idx]);
        }
      })(node);

      return descendents;
    };

    /**
     * wrap node with new tag.
     *
     * @param {Node} node
     * @param {Node} tagName of wrapper
     * @return {Node} - wrapper
     */
    var wrap = function (node, wrapperName) {
      var parent = node.parentNode;
      var wrapper = $('<' + wrapperName + '>')[0];

      parent.insertBefore(wrapper, node);
      wrapper.appendChild(node);

      return wrapper;
    };

    /**
     * insert node after preceding
     *
     * @param {Node} node
     * @param {Node} preceding - predicate function
     */
    var insertAfter = function (node, preceding) {
      var next = preceding.nextSibling, parent = preceding.parentNode;
      if (next) {
        parent.insertBefore(node, next);
      } else {
        parent.appendChild(node);
      }
      return node;
    };

    /**
     * append elements.
     *
     * @param {Node} node
     * @param {Collection} aChild
     */
    var appendChildNodes = function (node, aChild) {
      $.each(aChild, function (idx, child) {
        node.appendChild(child);
      });
      return node;
    };

    /**
     * returns whether boundaryPoint is left edge or not.
     *
     * @param {BoundaryPoint} point
     * @return {Boolean}
     */
    var isLeftEdgePoint = function (point) {
      return point.offset === 0;
    };

    /**
     * returns whether boundaryPoint is right edge or not.
     *
     * @param {BoundaryPoint} point
     * @return {Boolean}
     */
    var isRightEdgePoint = function (point) {
      return point.offset === nodeLength(point.node);
    };

    /**
     * returns whether boundaryPoint is edge or not.
     *
     * @param {BoundaryPoint} point
     * @return {Boolean}
     */
    var isEdgePoint = function (point) {
      return isLeftEdgePoint(point) || isRightEdgePoint(point);
    };

    /**
     * returns wheter node is left edge of ancestor or not.
     *
     * @param {Node} node
     * @param {Node} ancestor
     * @return {Boolean}
     */
    var isLeftEdgeOf = function (node, ancestor) {
      while (node && node !== ancestor) {
        if (position(node) !== 0) {
          return false;
        }
        node = node.parentNode;
      }

      return true;
    };

    /**
     * returns whether node is right edge of ancestor or not.
     *
     * @param {Node} node
     * @param {Node} ancestor
     * @return {Boolean}
     */
    var isRightEdgeOf = function (node, ancestor) {
      while (node && node !== ancestor) {
        if (position(node) !== nodeLength(node.parentNode) - 1) {
          return false;
        }
        node = node.parentNode;
      }

      return true;
    };

    /**
     * returns whether point is left edge of ancestor or not.
     * @param {BoundaryPoint} point
     * @param {Node} ancestor
     * @return {Boolean}
     */
    var isLeftEdgePointOf = function (point, ancestor) {
      return isLeftEdgePoint(point) && isLeftEdgeOf(point.node, ancestor);
    };

    /**
     * returns whether point is right edge of ancestor or not.
     * @param {BoundaryPoint} point
     * @param {Node} ancestor
     * @return {Boolean}
     */
    var isRightEdgePointOf = function (point, ancestor) {
      return isRightEdgePoint(point) && isRightEdgeOf(point.node, ancestor);
    };

    /**
     * returns offset from parent.
     *
     * @param {Node} node
     */
    var position = function (node) {
      var offset = 0;
      while ((node = node.previousSibling)) {
        offset += 1;
      }
      return offset;
    };

    var hasChildren = function (node) {
      return !!(node && node.childNodes && node.childNodes.length);
    };

    /**
     * returns previous boundaryPoint
     *
     * @param {BoundaryPoint} point
     * @param {Boolean} isSkipInnerOffset
     * @return {BoundaryPoint}
     */
    var prevPoint = function (point, isSkipInnerOffset) {
      var node, offset;

      if (point.offset === 0) {
        if (isEditable(point.node)) {
          return null;
        }

        node = point.node.parentNode;
        offset = position(point.node);
      } else if (hasChildren(point.node)) {
        node = point.node.childNodes[point.offset - 1];
        offset = nodeLength(node);
      } else {
        node = point.node;
        offset = isSkipInnerOffset ? 0 : point.offset - 1;
      }

      return {
        node: node,
        offset: offset
      };
    };

    /**
     * returns next boundaryPoint
     *
     * @param {BoundaryPoint} point
     * @param {Boolean} isSkipInnerOffset
     * @return {BoundaryPoint}
     */
    var nextPoint = function (point, isSkipInnerOffset) {
      var node, offset;

      if (nodeLength(point.node) === point.offset) {
        if (isEditable(point.node)) {
          return null;
        }

        node = point.node.parentNode;
        offset = position(point.node) + 1;
      } else if (hasChildren(point.node)) {
        node = point.node.childNodes[point.offset];
        offset = 0;
      } else {
        node = point.node;
        offset = isSkipInnerOffset ? nodeLength(point.node) : point.offset + 1;
      }

      return {
        node: node,
        offset: offset
      };
    };

    /**
     * returns whether pointA and pointB is same or not.
     *
     * @param {BoundaryPoint} pointA
     * @param {BoundaryPoint} pointB
     * @return {Boolean}
     */
    var isSamePoint = function (pointA, pointB) {
      return pointA.node === pointB.node && pointA.offset === pointB.offset;
    };

    /**
     * returns whether point is visible (can set cursor) or not.
     *
     * @param {BoundaryPoint} point
     * @return {Boolean}
     */
    var isVisiblePoint = function (point) {
      if (isText(point.node) || !hasChildren(point.node) || isEmpty(point.node)) {
        return true;
      }

      var leftNode = point.node.childNodes[point.offset - 1];
      var rightNode = point.node.childNodes[point.offset];
      if ((!leftNode || isVoid(leftNode)) && (!rightNode || isVoid(rightNode))) {
        return true;
      }

      return false;
    };

    /**
     * @method prevPointUtil
     *
     * @param {BoundaryPoint} point
     * @param {Function} pred
     * @return {BoundaryPoint}
     */
    var prevPointUntil = function (point, pred) {
      while (point) {
        if (pred(point)) {
          return point;
        }

        point = prevPoint(point);
      }

      return null;
    };

    /**
     * @method nextPointUntil
     *
     * @param {BoundaryPoint} point
     * @param {Function} pred
     * @return {BoundaryPoint}
     */
    var nextPointUntil = function (point, pred) {
      while (point) {
        if (pred(point)) {
          return point;
        }

        point = nextPoint(point);
      }

      return null;
    };

    /**
     * returns whether point has character or not.
     *
     * @param {Point} point
     * @return {Boolean}
     */
    var isCharPoint = function (point) {
      if (!isText(point.node)) {
        return false;
      }

      var ch = point.node.nodeValue.charAt(point.offset - 1);
      return ch && (ch !== ' ' && ch !== NBSP_CHAR);
    };

    /**
     * @method walkPoint
     *
     * @param {BoundaryPoint} startPoint
     * @param {BoundaryPoint} endPoint
     * @param {Function} handler
     * @param {Boolean} isSkipInnerOffset
     */
    var walkPoint = function (startPoint, endPoint, handler, isSkipInnerOffset) {
      var point = startPoint;

      while (point) {
        handler(point);

        if (isSamePoint(point, endPoint)) {
          break;
        }

        var isSkipOffset = isSkipInnerOffset &&
                           startPoint.node !== point.node &&
                           endPoint.node !== point.node;
        point = nextPoint(point, isSkipOffset);
      }
    };

    /**
     * @method makeOffsetPath
     *
     * return offsetPath(array of offset) from ancestor
     *
     * @param {Node} ancestor - ancestor node
     * @param {Node} node
     */
    var makeOffsetPath = function (ancestor, node) {
      var ancestors = listAncestor(node, func.eq(ancestor));
      return ancestors.map(position).reverse();
    };

    /**
     * @method fromOffsetPath
     *
     * return element from offsetPath(array of offset)
     *
     * @param {Node} ancestor - ancestor node
     * @param {array} offsets - offsetPath
     */
    var fromOffsetPath = function (ancestor, offsets) {
      var current = ancestor;
      for (var i = 0, len = offsets.length; i < len; i++) {
        if (current.childNodes.length <= offsets[i]) {
          current = current.childNodes[current.childNodes.length - 1];
        } else {
          current = current.childNodes[offsets[i]];
        }
      }
      return current;
    };

    /**
     * @method splitNode
     *
     * split element or #text
     *
     * @param {BoundaryPoint} point
     * @param {Object} [options]
     * @param {Boolean} [options.isSkipPaddingBlankHTML] - default: false
     * @param {Boolean} [options.isNotSplitEdgePoint] - default: false
     * @return {Node} right node of boundaryPoint
     */
    var splitNode = function (point, options) {
      var isSkipPaddingBlankHTML = options && options.isSkipPaddingBlankHTML;
      var isNotSplitEdgePoint = options && options.isNotSplitEdgePoint;

      // edge case
      if (isEdgePoint(point) && (isText(point.node) || isNotSplitEdgePoint)) {
        if (isLeftEdgePoint(point)) {
          return point.node;
        } else if (isRightEdgePoint(point)) {
          return point.node.nextSibling;
        }
      }

      // split #text
      if (isText(point.node)) {
        return point.node.splitText(point.offset);
      } else {
        var childNode = point.node.childNodes[point.offset];
        var clone = insertAfter(point.node.cloneNode(false), point.node);
        appendChildNodes(clone, listNext(childNode));

        if (!isSkipPaddingBlankHTML) {
          paddingBlankHTML(point.node);
          paddingBlankHTML(clone);
        }

        return clone;
      }
    };

    /**
     * @method splitTree
     *
     * split tree by point
     *
     * @param {Node} root - split root
     * @param {BoundaryPoint} point
     * @param {Object} [options]
     * @param {Boolean} [options.isSkipPaddingBlankHTML] - default: false
     * @param {Boolean} [options.isNotSplitEdgePoint] - default: false
     * @return {Node} right node of boundaryPoint
     */
    var splitTree = function (root, point, options) {
      // ex) [#text, <span>, <p>]
      var ancestors = listAncestor(point.node, func.eq(root));

      if (!ancestors.length) {
        return null;
      } else if (ancestors.length === 1) {
        return splitNode(point, options);
      }

      return ancestors.reduce(function (node, parent) {
        if (node === point.node) {
          node = splitNode(point, options);
        }

        return splitNode({
          node: parent,
          offset: node ? dom.position(node) : nodeLength(parent)
        }, options);
      });
    };

    /**
     * split point
     *
     * @param {Point} point
     * @param {Boolean} isInline
     * @return {Object}
     */
    var splitPoint = function (point, isInline) {
      // find splitRoot, container
      //  - inline: splitRoot is a child of paragraph
      //  - block: splitRoot is a child of bodyContainer
      var pred = isInline ? isPara : isBodyContainer;
      var ancestors = listAncestor(point.node, pred);
      var topAncestor = list.last(ancestors) || point.node;

      var splitRoot, container;
      if (pred(topAncestor)) {
        splitRoot = ancestors[ancestors.length - 2];
        container = topAncestor;
      } else {
        splitRoot = topAncestor;
        container = splitRoot.parentNode;
      }

      // if splitRoot is exists, split with splitTree
      var pivot = splitRoot && splitTree(splitRoot, point, {
        isSkipPaddingBlankHTML: isInline,
        isNotSplitEdgePoint: isInline
      });

      // if container is point.node, find pivot with point.offset
      if (!pivot && container === point.node) {
        pivot = point.node.childNodes[point.offset];
      }

      return {
        rightNode: pivot,
        container: container
      };
    };

    var create = function (nodeName) {
      return document.createElement(nodeName);
    };

    var createText = function (text) {
      return document.createTextNode(text);
    };

    /**
     * @method remove
     *
     * remove node, (isRemoveChild: remove child or not)
     *
     * @param {Node} node
     * @param {Boolean} isRemoveChild
     */
    var remove = function (node, isRemoveChild) {
      if (!node || !node.parentNode) { return; }
      if (node.removeNode) { return node.removeNode(isRemoveChild); }

      var parent = node.parentNode;
      if (!isRemoveChild) {
        var nodes = [];
        var i, len;
        for (i = 0, len = node.childNodes.length; i < len; i++) {
          nodes.push(node.childNodes[i]);
        }

        for (i = 0, len = nodes.length; i < len; i++) {
          parent.insertBefore(nodes[i], node);
        }
      }

      parent.removeChild(node);
    };

    /**
     * @method removeWhile
     *
     * @param {Node} node
     * @param {Function} pred
     */
    var removeWhile = function (node, pred) {
      while (node) {
        if (isEditable(node) || !pred(node)) {
          break;
        }

        var parent = node.parentNode;
        remove(node);
        node = parent;
      }
    };

    /**
     * @method replace
     *
     * replace node with provided nodeName
     *
     * @param {Node} node
     * @param {String} nodeName
     * @return {Node} - new node
     */
    var replace = function (node, nodeName) {
      if (node.nodeName.toUpperCase() === nodeName.toUpperCase()) {
        return node;
      }

      var newNode = create(nodeName);

      if (node.style.cssText) {
        newNode.style.cssText = node.style.cssText;
      }

      appendChildNodes(newNode, list.from(node.childNodes));
      insertAfter(newNode, node);
      remove(node);

      return newNode;
    };

    var isTextarea = makePredByNodeName('TEXTAREA');

    /**
     * @param {jQuery} $node
     * @param {Boolean} [stripLinebreaks] - default: false
     */
    var value = function ($node, stripLinebreaks) {
      var val = isTextarea($node[0]) ? $node.val() : $node.html();
      if (stripLinebreaks) {
        return val.replace(/[\n\r]/g, '');
      }
      return val;
    };

    /**
     * @method html
     *
     * get the HTML contents of node
     *
     * @param {jQuery} $node
     * @param {Boolean} [isNewlineOnBlock]
     */
    var html = function ($node, isNewlineOnBlock) {
      var markup = value($node);

      if (isNewlineOnBlock) {
        var regexTag = /<(\/?)(\b(?!!)[^>\s]*)(.*?)(\s*\/?>)/g;
        markup = markup.replace(regexTag, function (match, endSlash, name) {
          name = name.toUpperCase();
          var isEndOfInlineContainer = /^DIV|^TD|^TH|^P|^LI|^H[1-7]/.test(name) &&
                                       !!endSlash;
          var isBlockNode = /^BLOCKQUOTE|^TABLE|^TBODY|^TR|^HR|^UL|^OL/.test(name);

          return match + ((isEndOfInlineContainer || isBlockNode) ? '\n' : '');
        });
        markup = $.trim(markup);
      }

      return markup;
    };

    var posFromPlaceholder = function (placeholder) {
      var $placeholder = $(placeholder);
      var pos = $placeholder.offset();
      var height = $placeholder.outerHeight(true); // include margin

      return {
        left: pos.left,
        top: pos.top + height
      };
    };

    var attachEvents = function ($node, events) {
      Object.keys(events).forEach(function (key) {
        $node.on(key, events[key]);
      });
    };

    var detachEvents = function ($node, events) {
      Object.keys(events).forEach(function (key) {
        $node.off(key, events[key]);
      });
    };

    return {
      /** @property {String} NBSP_CHAR */
      NBSP_CHAR: NBSP_CHAR,
      /** @property {String} ZERO_WIDTH_NBSP_CHAR */
      ZERO_WIDTH_NBSP_CHAR: ZERO_WIDTH_NBSP_CHAR,
      /** @property {String} blank */
      blank: blankHTML,
      /** @property {String} emptyPara */
      emptyPara: '<p>' + blankHTML + '</p>',
      makePredByNodeName: makePredByNodeName,
      isEditable: isEditable,
      isControlSizing: isControlSizing,
      isText: isText,
      isElement: isElement,
      isVoid: isVoid,
      isPara: isPara,
      isPurePara: isPurePara,
      isHeading: isHeading,
      isInline: isInline,
      isBlock: func.not(isInline),
      isBodyInline: isBodyInline,
      isBody: isBody,
      isParaInline: isParaInline,
      isPre: isPre,
      isList: isList,
      isTable: isTable,
      isCell: isCell,
      isBlockquote: isBlockquote,
      isBodyContainer: isBodyContainer,
      isAnchor: isAnchor,
      isDiv: makePredByNodeName('DIV'),
      isLi: isLi,
      isBR: makePredByNodeName('BR'),
      isSpan: makePredByNodeName('SPAN'),
      isB: makePredByNodeName('B'),
      isU: makePredByNodeName('U'),
      isS: makePredByNodeName('S'),
      isI: makePredByNodeName('I'),
      isImg: makePredByNodeName('IMG'),
      isTextarea: isTextarea,
      isEmpty: isEmpty,
      isEmptyAnchor: func.and(isAnchor, isEmpty),
      isClosestSibling: isClosestSibling,
      withClosestSiblings: withClosestSiblings,
      nodeLength: nodeLength,
      isLeftEdgePoint: isLeftEdgePoint,
      isRightEdgePoint: isRightEdgePoint,
      isEdgePoint: isEdgePoint,
      isLeftEdgeOf: isLeftEdgeOf,
      isRightEdgeOf: isRightEdgeOf,
      isLeftEdgePointOf: isLeftEdgePointOf,
      isRightEdgePointOf: isRightEdgePointOf,
      prevPoint: prevPoint,
      nextPoint: nextPoint,
      isSamePoint: isSamePoint,
      isVisiblePoint: isVisiblePoint,
      prevPointUntil: prevPointUntil,
      nextPointUntil: nextPointUntil,
      isCharPoint: isCharPoint,
      walkPoint: walkPoint,
      ancestor: ancestor,
      singleChildAncestor: singleChildAncestor,
      listAncestor: listAncestor,
      lastAncestor: lastAncestor,
      listNext: listNext,
      listPrev: listPrev,
      listDescendant: listDescendant,
      commonAncestor: commonAncestor,
      wrap: wrap,
      insertAfter: insertAfter,
      appendChildNodes: appendChildNodes,
      position: position,
      hasChildren: hasChildren,
      makeOffsetPath: makeOffsetPath,
      fromOffsetPath: fromOffsetPath,
      splitTree: splitTree,
      splitPoint: splitPoint,
      create: create,
      createText: createText,
      remove: remove,
      removeWhile: removeWhile,
      replace: replace,
      html: html,
      value: value,
      posFromPlaceholder: posFromPlaceholder,
      attachEvents: attachEvents,
      detachEvents: detachEvents
    };
  })();


  /**
   * @param {jQuery} $note
   * @param {Object} options
   * @return {Context}
   */
  var Context = function ($note, options) {
    var self = this;

    var ui = $.summernote.ui;
    this.memos = {};
    this.modules = {};
    this.layoutInfo = {};
    this.options = options;

    /**
     * create layout and initialize modules and other resources
     */
    this.initialize = function () {
      this.layoutInfo = ui.createLayout($note, options);
      this._initialize();
      $note.hide();
      return this;
    };

    /**
     * destroy modules and other resources and remove layout
     */
    this.destroy = function () {
      this._destroy();
      $note.removeData('summernote');
      ui.removeLayout($note, this.layoutInfo);
    };

    /**
     * destory modules and other resources and initialize it again
     */
    this.reset = function () {
      this.code(dom.emptyPara);
      this._destroy();
      this._initialize();
    };

    this._initialize = function () {
      // add optional buttons
      var buttons = $.extend({}, this.options.buttons);
      Object.keys(buttons).forEach(function (key) {
        self.memo('button.' + key, buttons[key]);
      });

      var modules = $.extend({}, this.options.modules, $.summernote.plugins || {});

      // add and initialize modules
      Object.keys(modules).forEach(function (key) {
        self.module(key, modules[key], true);
      });

      Object.keys(this.modules).forEach(function (key) {
        self.initializeModule(key);
      });
    };

    this._destroy = function () {
      // destroy modules with reversed order
      Object.keys(this.modules).reverse().forEach(function (key) {
        self.removeModule(key);
      });

      Object.keys(this.memos).forEach(function (key) {
        self.removeMemo(key);
      });
    };

    this.code = function (html) {
      var isActivated = this.invoke('codeview.isActivated');

      if (html === undefined) {
        this.invoke('codeview.sync');
        return isActivated ? this.layoutInfo.codable.val() : this.layoutInfo.editable.html();
      } else {
        if (isActivated) {
          this.layoutInfo.codable.val(html);
        } else {
          this.layoutInfo.editable.html(html);
        }
        $note.val(html);
        this.triggerEvent('change', html);
      }
    };

    this.isDisabled = function () {
      return this.layoutInfo.editable.attr('contenteditable') === 'false';
    };

    this.enable = function () {
      this.layoutInfo.editable.attr('contenteditable', true);
      this.invoke('toolbar.activate', true);
    };

    this.disable = function () {
      // close codeview if codeview is opend
      if (this.invoke('codeview.isActivated')) {
        this.invoke('codeview.deactivate');
      }
      this.layoutInfo.editable.attr('contenteditable', false);
      this.invoke('toolbar.deactivate', true);
    };

    this.triggerEvent = function () {
      var namespace = list.head(arguments);
      var args = list.tail(list.from(arguments));

      var callback = this.options.callbacks[func.namespaceToCamel(namespace, 'on')];
      if (callback) {
        callback.apply($note[0], args);
      }
      $note.trigger('summernote.' + namespace, args);
    };

    this.initializeModule = function (key) {
      var module = this.modules[key];
      module.shouldInitialize = module.shouldInitialize || func.ok;
      if (!module.shouldInitialize()) {
        return;
      }

      // initialize module
      if (module.initialize) {
        module.initialize();
      }

      // attach events
      if (module.events) {
        dom.attachEvents($note, module.events);
      }
    };

    this.module = function (key, ModuleClass, withoutIntialize) {
      if (arguments.length === 1) {
        return this.modules[key];
      }

      this.modules[key] = new ModuleClass(this);

      if (!withoutIntialize) {
        this.initializeModule(key);
      }
    };

    this.removeModule = function (key) {
      var module = this.modules[key];
      if (module.shouldInitialize()) {
        if (module.events) {
          dom.detachEvents($note, module.events);
        }

        if (module.destroy) {
          module.destroy();
        }
      }

      delete this.modules[key];
    };

    this.memo = function (key, obj) {
      if (arguments.length === 1) {
        return this.memos[key];
      }
      this.memos[key] = obj;
    };

    this.removeMemo = function (key) {
      if (this.memos[key] && this.memos[key].destroy) {
        this.memos[key].destroy();
      }

      delete this.memos[key];
    };

    this.createInvokeHandler = function (namespace, value) {
      return function (event) {
        event.preventDefault();
        self.invoke(namespace, value || $(event.target).closest('[data-value]').data('value'));
      };
    };

    this.invoke = function () {
      var namespace = list.head(arguments);
      var args = list.tail(list.from(arguments));

      var splits = namespace.split('.');
      var hasSeparator = splits.length > 1;
      var moduleName = hasSeparator && list.head(splits);
      var methodName = hasSeparator ? list.last(splits) : list.head(splits);

      var module = this.modules[moduleName || 'editor'];
      if (!moduleName && this[methodName]) {
        return this[methodName].apply(this, args);
      } else if (module && module[methodName] && module.shouldInitialize()) {
        return module[methodName].apply(module, args);
      }
    };

    return this.initialize();
  };

  $.summernote = $.summernote || {
    lang: {}
  };

  $.fn.extend({
    /**
     * Summernote API
     *
     * @param {Object|String}
     * @return {this}
     */
    summernote: function () {
      var type = $.type(list.head(arguments));
      var isExternalAPICalled = type === 'string';
      var hasInitOptions = type === 'object';

      var options = hasInitOptions ? list.head(arguments) : {};

      options = $.extend({}, $.summernote.options, options);
      options.langInfo = $.extend(true, {}, $.summernote.lang['en-US'], $.summernote.lang[options.lang]);

      this.each(function (idx, note) {
        var $note = $(note);
        if (!$note.data('summernote')) {
          var context = new Context($note, options);
          $note.data('summernote', context);
          $note.data('summernote').triggerEvent('init', context.layoutInfo);
        }
      });

      var $note = this.first();
      if ($note.length) {
        var context = $note.data('summernote');
        if (isExternalAPICalled) {
          return context.invoke.apply(context, list.from(arguments));
        } else if (options.focus) {
          context.invoke('editor.focus');
        }
      }

      return this;
    }
  });


  var Renderer = function (markup, children, options, callback) {
    this.render = function ($parent) {
      var $node = $(markup);

      if (options && options.contents) {
        $node.html(options.contents);
      }

      if (options && options.className) {
        $node.addClass(options.className);
      }

      if (options && options.data) {
        $.each(options.data, function (k, v) {
          $node.attr('data-' + k, v);
        });
      }

      if (options && options.click) {
        $node.on('click', options.click);
      }

      if (children) {
        var $container = $node.find('.note-children-container');
        children.forEach(function (child) {
          child.render($container.length ? $container : $node);
        });
      }

      if (callback) {
        callback($node, options);
      }

      if (options && options.callback) {
        options.callback($node);
      }

      if ($parent) {
        $parent.append($node);
      }

      return $node;
    };
  };

  var renderer = {
    create: function (markup, callback) {
      return function () {
        var children = $.isArray(arguments[0]) ? arguments[0] : [];
        var options = typeof arguments[1] === 'object' ? arguments[1] : arguments[0];
        if (options && options.children) {
          children = options.children;
        }
        return new Renderer(markup, children, options, callback);
      };
    }
  };

  var editor = renderer.create('<div class="note-editor note-frame panel panel-default"/>');
  var toolbar = renderer.create('<div class="note-toolbar panel-heading"/>');
  var editingArea = renderer.create('<div class="note-editing-area"/>');
  var codable = renderer.create('<textarea class="note-codable"/>');
  var editable = renderer.create('<div class="note-editable panel-body" contentEditable="true"/>');
  var statusbar = renderer.create([
    '<div class="note-statusbar">',
    '  <div class="note-resizebar">',
    '    <div class="note-icon-bar"/>',
    '    <div class="note-icon-bar"/>',
    '    <div class="note-icon-bar"/>',
    '  </div>',
    '</div>'
  ].join(''));

  var airEditor = renderer.create('<div class="note-editor"/>');
  var airEditable = renderer.create('<div class="note-editable" contentEditable="true"/>');

  var buttonGroup = renderer.create('<div class="note-btn-group btn-group">');
  var button = renderer.create('<button type="button" class="note-btn btn btn-default btn-sm">', function ($node, options) {
    if (options && options.tooltip) {
      $node.attr({
        title: options.tooltip
      }).tooltip({
        container: 'body',
        trigger: 'hover',
        placement: 'bottom'
      });
    }
  });

  var dropdown = renderer.create('<div class="dropdown-menu">', function ($node, options) {
    var markup = $.isArray(options.items) ? options.items.map(function (item) {
      var value = (typeof item === 'string') ? item : (item.value || '');
      var content = options.template ? options.template(item) : item;
      return '<li><a href="#" data-value="' + value + '">' + content + '</a></li>';
    }).join('') : options.items;

    $node.html(markup);
  });

  var dropdownCheck = renderer.create('<div class="dropdown-menu note-check">', function ($node, options) {
    var markup = $.isArray(options.items) ? options.items.map(function (item) {
      var value = (typeof item === 'string') ? item : (item.value || '');
      var content = options.template ? options.template(item) : item;
      return '<li><a href="#" data-value="' + value + '">' + icon(options.checkClassName) + ' ' + content + '</a></li>';
    }).join('') : options.items;
    $node.html(markup);
  });

  var palette = renderer.create('<div class="note-color-palette"/>', function ($node, options) {
    var contents = [];
    for (var row = 0, rowSize = options.colors.length; row < rowSize; row++) {
      var eventName = options.eventName;
      var colors = options.colors[row];
      var buttons = [];
      for (var col = 0, colSize = colors.length; col < colSize; col++) {
        var color = colors[col];
        buttons.push([
          '<button type="button" class="note-color-btn"',
          'style="background-color:', color, '" ',
          'data-event="', eventName, '" ',
          'data-value="', color, '" ',
          'title="', color, '" ',
          'data-toggle="button" tabindex="-1"></button>'
        ].join(''));
      }
      contents.push('<div class="note-color-row">' + buttons.join('') + '</div>');
    }
    $node.html(contents.join(''));

    $node.find('.note-color-btn').tooltip({
      container: 'body',
      trigger: 'hover',
      placement: 'bottom'
    });
  });

  var dialog = renderer.create('<div class="modal" aria-hidden="false" tabindex="-1"/>', function ($node, options) {
    if (options.fade) {
      $node.addClass('fade');
    }
    $node.html([
      '<div class="modal-dialog">',
      '  <div class="modal-content">',
      (options.title ?
      '    <div class="modal-header">' +
      '      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
      '      <h4 class="modal-title">' + options.title + '</h4>' +
      '    </div>' : ''
      ),
      '    <div class="modal-body">' + options.body + '</div>',
      (options.footer ?
      '    <div class="modal-footer">' + options.footer + '</div>' : ''
      ),
      '  </div>',
      '</div>'
    ].join(''));
  });

  var popover = renderer.create([
    '<div class="note-popover popover in">',
    '  <div class="arrow"/>',
    '  <div class="popover-content note-children-container"/>',
    '</div>'
  ].join(''), function ($node, options) {
    var direction = typeof options.direction !== 'undefined' ? options.direction : 'bottom';

    $node.addClass(direction);

    if (options.hideArrow) {
      $node.find('.arrow').hide();
    }
  });

  var icon = function (iconClassName, tagName) {
    tagName = tagName || 'i';
    return '<' + tagName + ' class="' + iconClassName + '"/>';
  };

  var ui = {
    editor: editor,
    toolbar: toolbar,
    editingArea: editingArea,
    codable: codable,
    editable: editable,
    statusbar: statusbar,
    airEditor: airEditor,
    airEditable: airEditable,
    buttonGroup: buttonGroup,
    button: button,
    dropdown: dropdown,
    dropdownCheck: dropdownCheck,
    palette: palette,
    dialog: dialog,
    popover: popover,
    icon: icon,

    toggleBtn: function ($btn, isEnable) {
      $btn.toggleClass('disabled', !isEnable);
      $btn.attr('disabled', !isEnable);
    },

    toggleBtnActive: function ($btn, isActive) {
      $btn.toggleClass('active', isActive);
    },

    onDialogShown: function ($dialog, handler) {
      $dialog.one('shown.bs.modal', handler);
    },

    onDialogHidden: function ($dialog, handler) {
      $dialog.one('hidden.bs.modal', handler);
    },

    showDialog: function ($dialog) {
      $dialog.modal('show');
    },

    hideDialog: function ($dialog) {
      $dialog.modal('hide');
    },

    createLayout: function ($note, options) {
      var $editor = (options.airMode ? ui.airEditor([
        ui.editingArea([
          ui.airEditable()
        ])
      ]) : ui.editor([
        ui.toolbar(),
        ui.editingArea([
          ui.codable(),
          ui.editable()
        ]),
        ui.statusbar()
      ])).render();

      $editor.insertAfter($note);

      return {
        note: $note,
        editor: $editor,
        toolbar: $editor.find('.note-toolbar'),
        editingArea: $editor.find('.note-editing-area'),
        editable: $editor.find('.note-editable'),
        codable: $editor.find('.note-codable'),
        statusbar: $editor.find('.note-statusbar')
      };
    },

    removeLayout: function ($note, layoutInfo) {
      $note.html(layoutInfo.editable.html());
      layoutInfo.editor.remove();
      $note.show();
    }
  };

  $.extend($.summernote.lang, {
    'en-US': {
      font: {
        bold: 'Bold',
        italic: 'Italic',
        underline: 'Underline',
        clear: 'Remove Font Style',
        height: 'Line Height',
        name: 'Font Family',
        strikethrough: 'Strikethrough',
        subscript: 'Subscript',
        superscript: 'Superscript',
        size: 'Font Size'
      },
      image: {
        image: 'Picture',
        insert: 'Insert Image',
        resizeFull: 'Resize Full',
        resizeHalf: 'Resize Half',
        resizeQuarter: 'Resize Quarter',
        floatLeft: 'Float Left',
        floatRight: 'Float Right',
        floatNone: 'Float None',
        shapeRounded: 'Shape: Rounded',
        shapeCircle: 'Shape: Circle',
        shapeThumbnail: 'Shape: Thumbnail',
        shapeNone: 'Shape: None',
        dragImageHere: 'Drag image or text here',
        dropImage: 'Drop image or Text',
        selectFromFiles: 'Select from files',
        maximumFileSize: 'Maximum file size',
        maximumFileSizeError: 'Maximum file size exceeded.',
        url: 'Image URL',
        remove: 'Remove Image'
      },
      video: {
        video: 'Video',
        videoLink: 'Video Link',
        insert: 'Insert Video',
        url: 'Video URL?',
        providers: '(YouTube, Vimeo, Vine, Instagram, DailyMotion or Youku)'
      },
      link: {
        link: 'Link',
        insert: 'Insert Link',
        unlink: 'Unlink',
        edit: 'Edit',
        textToDisplay: 'Text to display',
        url: 'To what URL should this link go?',
        openInNewWindow: 'Open in new window'
      },
      table: {
        table: 'Table'
      },
      hr: {
        insert: 'Insert Horizontal Rule'
      },
      style: {
        style: 'Style',
        normal: 'Normal',
        blockquote: 'Quote',
        pre: 'Code',
        h1: 'Header 1',
        h2: 'Header 2',
        h3: 'Header 3',
        h4: 'Header 4',
        h5: 'Header 5',
        h6: 'Header 6'
      },
      lists: {
        unordered: 'Unordered list',
        ordered: 'Ordered list'
      },
      options: {
        help: 'Help',
        fullscreen: 'Full Screen',
        codeview: 'Code View'
      },
      paragraph: {
        paragraph: 'Paragraph',
        outdent: 'Outdent',
        indent: 'Indent',
        left: 'Align left',
        center: 'Align center',
        right: 'Align right',
        justify: 'Justify full'
      },
      color: {
        recent: 'Recent Color',
        more: 'More Color',
        background: 'Background Color',
        foreground: 'Foreground Color',
        transparent: 'Transparent',
        setTransparent: 'Set transparent',
        reset: 'Reset',
        resetToDefault: 'Reset to default'
      },
      shortcut: {
        shortcuts: 'Keyboard shortcuts',
        close: 'Close',
        textFormatting: 'Text formatting',
        action: 'Action',
        paragraphFormatting: 'Paragraph formatting',
        documentStyle: 'Document Style',
        extraKeys: 'Extra keys'
      },
      help: {
        'insertParagraph': 'Insert Paragraph',
        'undo': 'Undoes the last command',
        'redo': 'Redoes the last command',
        'tab': 'Tab',
        'untab': 'Untab',
        'bold': 'Set a bold style',
        'italic': 'Set a italic style',
        'underline': 'Set a underline style',
        'strikethrough': 'Set a strikethrough style',
        'removeFormat': 'Clean a style',
        'justifyLeft': 'Set left align',
        'justifyCenter': 'Set center align',
        'justifyRight': 'Set right align',
        'justifyFull': 'Set full align',
        'insertUnorderedList': 'Toggle unordered list',
        'insertOrderedList': 'Toggle ordered list',
        'outdent': 'Outdent on current paragraph',
        'indent': 'Indent on current paragraph',
        'formatPara': 'Change current block\'s format as a paragraph(P tag)',
        'formatH1': 'Change current block\'s format as H1',
        'formatH2': 'Change current block\'s format as H2',
        'formatH3': 'Change current block\'s format as H3',
        'formatH4': 'Change current block\'s format as H4',
        'formatH5': 'Change current block\'s format as H5',
        'formatH6': 'Change current block\'s format as H6',
        'insertHorizontalRule': 'Insert horizontal rule',
        'linkDialog.show': 'Show Link Dialog'
      },
      history: {
        undo: 'Undo',
        redo: 'Redo'
      },
      specialChar: {
        specialChar: 'SPECIAL CHARACTERS',
        select: 'Select Special characters'
      }
    }
  });


  /**
   * @class core.key
   *
   * Object for keycodes.
   *
   * @singleton
   * @alternateClassName key
   */
  var key = (function () {
    var keyMap = {
      'BACKSPACE': 8,
      'TAB': 9,
      'ENTER': 13,
      'SPACE': 32,

      // Arrow
      'LEFT': 37,
      'UP': 38,
      'RIGHT': 39,
      'DOWN': 40,

      // Number: 0-9
      'NUM0': 48,
      'NUM1': 49,
      'NUM2': 50,
      'NUM3': 51,
      'NUM4': 52,
      'NUM5': 53,
      'NUM6': 54,
      'NUM7': 55,
      'NUM8': 56,

      // Alphabet: a-z
      'B': 66,
      'E': 69,
      'I': 73,
      'J': 74,
      'K': 75,
      'L': 76,
      'R': 82,
      'S': 83,
      'U': 85,
      'V': 86,
      'Y': 89,
      'Z': 90,

      'SLASH': 191,
      'LEFTBRACKET': 219,
      'BACKSLASH': 220,
      'RIGHTBRACKET': 221
    };

    return {
      /**
       * @method isEdit
       *
       * @param {Number} keyCode
       * @return {Boolean}
       */
      isEdit: function (keyCode) {
        return list.contains([
          keyMap.BACKSPACE,
          keyMap.TAB,
          keyMap.ENTER,
          keyMap.SPACe
        ], keyCode);
      },
      /**
       * @method isMove
       *
       * @param {Number} keyCode
       * @return {Boolean}
       */
      isMove: function (keyCode) {
        return list.contains([
          keyMap.LEFT,
          keyMap.UP,
          keyMap.RIGHT,
          keyMap.DOWN
        ], keyCode);
      },
      /**
       * @property {Object} nameFromCode
       * @property {String} nameFromCode.8 "BACKSPACE"
       */
      nameFromCode: func.invertObject(keyMap),
      code: keyMap
    };
  })();


  var range = (function () {

    /**
     * return boundaryPoint from TextRange, inspired by Andy Na's HuskyRange.js
     *
     * @param {TextRange} textRange
     * @param {Boolean} isStart
     * @return {BoundaryPoint}
     *
     * @see http://msdn.microsoft.com/en-us/library/ie/ms535872(v=vs.85).aspx
     */
    var textRangeToPoint = function (textRange, isStart) {
      var container = textRange.parentElement(), offset;

      var tester = document.body.createTextRange(), prevContainer;
      var childNodes = list.from(container.childNodes);
      for (offset = 0; offset < childNodes.length; offset++) {
        if (dom.isText(childNodes[offset])) {
          continue;
        }
        tester.moveToElementText(childNodes[offset]);
        if (tester.compareEndPoints('StartToStart', textRange) >= 0) {
          break;
        }
        prevContainer = childNodes[offset];
      }

      if (offset !== 0 && dom.isText(childNodes[offset - 1])) {
        var textRangeStart = document.body.createTextRange(), curTextNode = null;
        textRangeStart.moveToElementText(prevContainer || container);
        textRangeStart.collapse(!prevContainer);
        curTextNode = prevContainer ? prevContainer.nextSibling : container.firstChild;

        var pointTester = textRange.duplicate();
        pointTester.setEndPoint('StartToStart', textRangeStart);
        var textCount = pointTester.text.replace(/[\r\n]/g, '').length;

        while (textCount > curTextNode.nodeValue.length && curTextNode.nextSibling) {
          textCount -= curTextNode.nodeValue.length;
          curTextNode = curTextNode.nextSibling;
        }

        /* jshint ignore:start */
        var dummy = curTextNode.nodeValue; // enforce IE to re-reference curTextNode, hack
        /* jshint ignore:end */

        if (isStart && curTextNode.nextSibling && dom.isText(curTextNode.nextSibling) &&
            textCount === curTextNode.nodeValue.length) {
          textCount -= curTextNode.nodeValue.length;
          curTextNode = curTextNode.nextSibling;
        }

        container = curTextNode;
        offset = textCount;
      }

      return {
        cont: container,
        offset: offset
      };
    };

    /**
     * return TextRange from boundary point (inspired by google closure-library)
     * @param {BoundaryPoint} point
     * @return {TextRange}
     */
    var pointToTextRange = function (point) {
      var textRangeInfo = function (container, offset) {
        var node, isCollapseToStart;

        if (dom.isText(container)) {
          var prevTextNodes = dom.listPrev(container, func.not(dom.isText));
          var prevContainer = list.last(prevTextNodes).previousSibling;
          node =  prevContainer || container.parentNode;
          offset += list.sum(list.tail(prevTextNodes), dom.nodeLength);
          isCollapseToStart = !prevContainer;
        } else {
          node = container.childNodes[offset] || container;
          if (dom.isText(node)) {
            return textRangeInfo(node, 0);
          }

          offset = 0;
          isCollapseToStart = false;
        }

        return {
          node: node,
          collapseToStart: isCollapseToStart,
          offset: offset
        };
      };

      var textRange = document.body.createTextRange();
      var info = textRangeInfo(point.node, point.offset);

      textRange.moveToElementText(info.node);
      textRange.collapse(info.collapseToStart);
      textRange.moveStart('character', info.offset);
      return textRange;
    };

    /**
     * Wrapped Range
     *
     * @constructor
     * @param {Node} sc - start container
     * @param {Number} so - start offset
     * @param {Node} ec - end container
     * @param {Number} eo - end offset
     */
    var WrappedRange = function (sc, so, ec, eo) {
      this.sc = sc;
      this.so = so;
      this.ec = ec;
      this.eo = eo;

      // nativeRange: get nativeRange from sc, so, ec, eo
      var nativeRange = function () {
        if (agent.isW3CRangeSupport) {
          var w3cRange = document.createRange();
          w3cRange.setStart(sc, so);
          w3cRange.setEnd(ec, eo);

          return w3cRange;
        } else {
          var textRange = pointToTextRange({
            node: sc,
            offset: so
          });

          textRange.setEndPoint('EndToEnd', pointToTextRange({
            node: ec,
            offset: eo
          }));

          return textRange;
        }
      };

      this.getPoints = function () {
        return {
          sc: sc,
          so: so,
          ec: ec,
          eo: eo
        };
      };

      this.getStartPoint = function () {
        return {
          node: sc,
          offset: so
        };
      };

      this.getEndPoint = function () {
        return {
          node: ec,
          offset: eo
        };
      };

      /**
       * select update visible range
       */
      this.select = function () {
        var nativeRng = nativeRange();
        if (agent.isW3CRangeSupport) {
          var selection = document.getSelection();
          if (selection.rangeCount > 0) {
            selection.removeAllRanges();
          }
          selection.addRange(nativeRng);
        } else {
          nativeRng.select();
        }

        return this;
      };


      /**
       * Moves the scrollbar to start container(sc) of current range
       *
       * @return {WrappedRange}
       */
      this.scrollIntoView = function ($container) {
        if ($container[0].scrollTop + $container.height() < this.sc.offsetTop) {
          $container[0].scrollTop += Math.abs($container[0].scrollTop + $container.height() - this.sc.offsetTop);
        }

        return this;
      };

      /**
       * @return {WrappedRange}
       */
      this.normalize = function () {

        /**
         * @param {BoundaryPoint} point
         * @param {Boolean} isLeftToRight
         * @return {BoundaryPoint}
         */
        var getVisiblePoint = function (point, isLeftToRight) {
          if ((dom.isVisiblePoint(point) && !dom.isEdgePoint(point)) ||
              (dom.isVisiblePoint(point) && dom.isRightEdgePoint(point) && !isLeftToRight) ||
              (dom.isVisiblePoint(point) && dom.isLeftEdgePoint(point) && isLeftToRight) ||
              (dom.isVisiblePoint(point) && dom.isBlock(point.node) && dom.isEmpty(point.node))) {
            return point;
          }

          // point on block's edge
          var block = dom.ancestor(point.node, dom.isBlock);
          if (((dom.isLeftEdgePointOf(point, block) || dom.isVoid(dom.prevPoint(point).node)) && !isLeftToRight) ||
              ((dom.isRightEdgePointOf(point, block) || dom.isVoid(dom.nextPoint(point).node)) && isLeftToRight)) {

            // returns point already on visible point
            if (dom.isVisiblePoint(point)) {
              return point;
            }
            // reverse direction
            isLeftToRight = !isLeftToRight;
          }

          var nextPoint = isLeftToRight ? dom.nextPointUntil(dom.nextPoint(point), dom.isVisiblePoint) :
                                          dom.prevPointUntil(dom.prevPoint(point), dom.isVisiblePoint);
          return nextPoint || point;
        };

        var endPoint = getVisiblePoint(this.getEndPoint(), false);
        var startPoint = this.isCollapsed() ? endPoint : getVisiblePoint(this.getStartPoint(), true);

        return new WrappedRange(
          startPoint.node,
          startPoint.offset,
          endPoint.node,
          endPoint.offset
        );
      };

      /**
       * returns matched nodes on range
       *
       * @param {Function} [pred] - predicate function
       * @param {Object} [options]
       * @param {Boolean} [options.includeAncestor]
       * @param {Boolean} [options.fullyContains]
       * @return {Node[]}
       */
      this.nodes = function (pred, options) {
        pred = pred || func.ok;

        var includeAncestor = options && options.includeAncestor;
        var fullyContains = options && options.fullyContains;

        // TODO compare points and sort
        var startPoint = this.getStartPoint();
        var endPoint = this.getEndPoint();

        var nodes = [];
        var leftEdgeNodes = [];

        dom.walkPoint(startPoint, endPoint, function (point) {
          if (dom.isEditable(point.node)) {
            return;
          }

          var node;
          if (fullyContains) {
            if (dom.isLeftEdgePoint(point)) {
              leftEdgeNodes.push(point.node);
            }
            if (dom.isRightEdgePoint(point) && list.contains(leftEdgeNodes, point.node)) {
              node = point.node;
            }
          } else if (includeAncestor) {
            node = dom.ancestor(point.node, pred);
          } else {
            node = point.node;
          }

          if (node && pred(node)) {
            nodes.push(node);
          }
        }, true);

        return list.unique(nodes);
      };

      /**
       * returns commonAncestor of range
       * @return {Element} - commonAncestor
       */
      this.commonAncestor = function () {
        return dom.commonAncestor(sc, ec);
      };

      /**
       * returns expanded range by pred
       *
       * @param {Function} pred - predicate function
       * @return {WrappedRange}
       */
      this.expand = function (pred) {
        var startAncestor = dom.ancestor(sc, pred);
        var endAncestor = dom.ancestor(ec, pred);

        if (!startAncestor && !endAncestor) {
          return new WrappedRange(sc, so, ec, eo);
        }

        var boundaryPoints = this.getPoints();

        if (startAncestor) {
          boundaryPoints.sc = startAncestor;
          boundaryPoints.so = 0;
        }

        if (endAncestor) {
          boundaryPoints.ec = endAncestor;
          boundaryPoints.eo = dom.nodeLength(endAncestor);
        }

        return new WrappedRange(
          boundaryPoints.sc,
          boundaryPoints.so,
          boundaryPoints.ec,
          boundaryPoints.eo
        );
      };

      /**
       * @param {Boolean} isCollapseToStart
       * @return {WrappedRange}
       */
      this.collapse = function (isCollapseToStart) {
        if (isCollapseToStart) {
          return new WrappedRange(sc, so, sc, so);
        } else {
          return new WrappedRange(ec, eo, ec, eo);
        }
      };

      /**
       * splitText on range
       */
      this.splitText = function () {
        var isSameContainer = sc === ec;
        var boundaryPoints = this.getPoints();

        if (dom.isText(ec) && !dom.isEdgePoint(this.getEndPoint())) {
          ec.splitText(eo);
        }

        if (dom.isText(sc) && !dom.isEdgePoint(this.getStartPoint())) {
          boundaryPoints.sc = sc.splitText(so);
          boundaryPoints.so = 0;

          if (isSameContainer) {
            boundaryPoints.ec = boundaryPoints.sc;
            boundaryPoints.eo = eo - so;
          }
        }

        return new WrappedRange(
          boundaryPoints.sc,
          boundaryPoints.so,
          boundaryPoints.ec,
          boundaryPoints.eo
        );
      };

      /**
       * delete contents on range
       * @return {WrappedRange}
       */
      this.deleteContents = function () {
        if (this.isCollapsed()) {
          return this;
        }

        var rng = this.splitText();
        var nodes = rng.nodes(null, {
          fullyContains: true
        });

        // find new cursor point
        var point = dom.prevPointUntil(rng.getStartPoint(), function (point) {
          return !list.contains(nodes, point.node);
        });

        var emptyParents = [];
        $.each(nodes, function (idx, node) {
          // find empty parents
          var parent = node.parentNode;
          if (point.node !== parent && dom.nodeLength(parent) === 1) {
            emptyParents.push(parent);
          }
          dom.remove(node, false);
        });

        // remove empty parents
        $.each(emptyParents, function (idx, node) {
          dom.remove(node, false);
        });

        return new WrappedRange(
          point.node,
          point.offset,
          point.node,
          point.offset
        ).normalize();
      };

      /**
       * makeIsOn: return isOn(pred) function
       */
      var makeIsOn = function (pred) {
        return function () {
          var ancestor = dom.ancestor(sc, pred);
          return !!ancestor && (ancestor === dom.ancestor(ec, pred));
        };
      };

      // isOnEditable: judge whether range is on editable or not
      this.isOnEditable = makeIsOn(dom.isEditable);
      // isOnList: judge whether range is on list node or not
      this.isOnList = makeIsOn(dom.isList);
      // isOnAnchor: judge whether range is on anchor node or not
      this.isOnAnchor = makeIsOn(dom.isAnchor);
      // isOnAnchor: judge whether range is on cell node or not
      this.isOnCell = makeIsOn(dom.isCell);

      /**
       * @param {Function} pred
       * @return {Boolean}
       */
      this.isLeftEdgeOf = function (pred) {
        if (!dom.isLeftEdgePoint(this.getStartPoint())) {
          return false;
        }

        var node = dom.ancestor(this.sc, pred);
        return node && dom.isLeftEdgeOf(this.sc, node);
      };

      /**
       * returns whether range was collapsed or not
       */
      this.isCollapsed = function () {
        return sc === ec && so === eo;
      };

      /**
       * wrap inline nodes which children of body with paragraph
       *
       * @return {WrappedRange}
       */
      this.wrapBodyInlineWithPara = function () {
        if (dom.isBodyContainer(sc) && dom.isEmpty(sc)) {
          sc.innerHTML = dom.emptyPara;
          return new WrappedRange(sc.firstChild, 0, sc.firstChild, 0);
        }

        /**
         * [workaround] firefox often create range on not visible point. so normalize here.
         *  - firefox: |<p>text</p>|
         *  - chrome: <p>|text|</p>
         */
        var rng = this.normalize();
        if (dom.isParaInline(sc) || dom.isPara(sc)) {
          return rng;
        }

        // find inline top ancestor
        var topAncestor;
        if (dom.isInline(rng.sc)) {
          var ancestors = dom.listAncestor(rng.sc, func.not(dom.isInline));
          topAncestor = list.last(ancestors);
          if (!dom.isInline(topAncestor)) {
            topAncestor = ancestors[ancestors.length - 2] || rng.sc.childNodes[rng.so];
          }
        } else {
          topAncestor = rng.sc.childNodes[rng.so > 0 ? rng.so - 1 : 0];
        }

        // siblings not in paragraph
        var inlineSiblings = dom.listPrev(topAncestor, dom.isParaInline).reverse();
        inlineSiblings = inlineSiblings.concat(dom.listNext(topAncestor.nextSibling, dom.isParaInline));

        // wrap with paragraph
        if (inlineSiblings.length) {
          var para = dom.wrap(list.head(inlineSiblings), 'p');
          dom.appendChildNodes(para, list.tail(inlineSiblings));
        }

        return this.normalize();
      };

      /**
       * insert node at current cursor
       *
       * @param {Node} node
       * @return {Node}
       */
      this.insertNode = function (node) {
        var rng = this.wrapBodyInlineWithPara().deleteContents();
        var info = dom.splitPoint(rng.getStartPoint(), dom.isInline(node));

        if (info.rightNode) {
          info.rightNode.parentNode.insertBefore(node, info.rightNode);
        } else {
          info.container.appendChild(node);
        }

        return node;
      };

      /**
       * insert html at current cursor
       */
      this.pasteHTML = function (markup) {
        var contentsContainer = $('<div></div>').html(markup)[0];
        var childNodes = list.from(contentsContainer.childNodes);

        var rng = this.wrapBodyInlineWithPara().deleteContents();

        return childNodes.reverse().map(function (childNode) {
          return rng.insertNode(childNode);
        }).reverse();
      };

      /**
       * returns text in range
       *
       * @return {String}
       */
      this.toString = function () {
        var nativeRng = nativeRange();
        return agent.isW3CRangeSupport ? nativeRng.toString() : nativeRng.text;
      };

      /**
       * returns range for word before cursor
       *
       * @param {Boolean} [findAfter] - find after cursor, default: false
       * @return {WrappedRange}
       */
      this.getWordRange = function (findAfter) {
        var endPoint = this.getEndPoint();

        if (!dom.isCharPoint(endPoint)) {
          return this;
        }

        var startPoint = dom.prevPointUntil(endPoint, function (point) {
          return !dom.isCharPoint(point);
        });

        if (findAfter) {
          endPoint = dom.nextPointUntil(endPoint, function (point) {
            return !dom.isCharPoint(point);
          });
        }

        return new WrappedRange(
          startPoint.node,
          startPoint.offset,
          endPoint.node,
          endPoint.offset
        );
      };

      /**
       * create offsetPath bookmark
       *
       * @param {Node} editable
       */
      this.bookmark = function (editable) {
        return {
          s: {
            path: dom.makeOffsetPath(editable, sc),
            offset: so
          },
          e: {
            path: dom.makeOffsetPath(editable, ec),
            offset: eo
          }
        };
      };

      /**
       * create offsetPath bookmark base on paragraph
       *
       * @param {Node[]} paras
       */
      this.paraBookmark = function (paras) {
        return {
          s: {
            path: list.tail(dom.makeOffsetPath(list.head(paras), sc)),
            offset: so
          },
          e: {
            path: list.tail(dom.makeOffsetPath(list.last(paras), ec)),
            offset: eo
          }
        };
      };

      /**
       * getClientRects
       * @return {Rect[]}
       */
      this.getClientRects = function () {
        var nativeRng = nativeRange();
        return nativeRng.getClientRects();
      };
    };

  /**
   * @class core.range
   *
   * Data structure
   *  * BoundaryPoint: a point of dom tree
   *  * BoundaryPoints: two boundaryPoints corresponding to the start and the end of the Range
   *
   * See to http://www.w3.org/TR/DOM-Level-2-Traversal-Range/ranges.html#Level-2-Range-Position
   *
   * @singleton
   * @alternateClassName range
   */
    return {
      /**
       * @method
       *
       * create Range Object From arguments or Browser Selection
       *
       * @param {Node} sc - start container
       * @param {Number} so - start offset
       * @param {Node} ec - end container
       * @param {Number} eo - end offset
       * @return {WrappedRange}
       */
      create: function (sc, so, ec, eo) {
        if (!arguments.length) { // from Browser Selection
          if (agent.isW3CRangeSupport) {
            var selection = document.getSelection();
            if (!selection || selection.rangeCount === 0) {
              return null;
            } else if (dom.isBody(selection.anchorNode)) {
              // Firefox: returns entire body as range on initialization. We won't never need it.
              return null;
            }

            var nativeRng = selection.getRangeAt(0);
            sc = nativeRng.startContainer;
            so = nativeRng.startOffset;
            ec = nativeRng.endContainer;
            eo = nativeRng.endOffset;
          } else { // IE8: TextRange
            var textRange = document.selection.createRange();
            var textRangeEnd = textRange.duplicate();
            textRangeEnd.collapse(false);
            var textRangeStart = textRange;
            textRangeStart.collapse(true);

            var startPoint = textRangeToPoint(textRangeStart, true),
            endPoint = textRangeToPoint(textRangeEnd, false);

            // same visible point case: range was collapsed.
            if (dom.isText(startPoint.node) && dom.isLeftEdgePoint(startPoint) &&
                dom.isTextNode(endPoint.node) && dom.isRightEdgePoint(endPoint) &&
                endPoint.node.nextSibling === startPoint.node) {
              startPoint = endPoint;
            }

            sc = startPoint.cont;
            so = startPoint.offset;
            ec = endPoint.cont;
            eo = endPoint.offset;
          }
        } else if (arguments.length === 2) { //collapsed
          ec = sc;
          eo = so;
        }
        return new WrappedRange(sc, so, ec, eo);
      },

      /**
       * @method
       *
       * create WrappedRange from node
       *
       * @param {Node} node
       * @return {WrappedRange}
       */
      createFromNode: function (node) {
        var sc = node;
        var so = 0;
        var ec = node;
        var eo = dom.nodeLength(ec);

        // browsers can't target a picture or void node
        if (dom.isVoid(sc)) {
          so = dom.listPrev(sc).length - 1;
          sc = sc.parentNode;
        }
        if (dom.isBR(ec)) {
          eo = dom.listPrev(ec).length - 1;
          ec = ec.parentNode;
        } else if (dom.isVoid(ec)) {
          eo = dom.listPrev(ec).length;
          ec = ec.parentNode;
        }

        return this.create(sc, so, ec, eo);
      },

      /**
       * create WrappedRange from node after position
       *
       * @param {Node} node
       * @return {WrappedRange}
       */
      createFromNodeBefore: function (node) {
        return this.createFromNode(node).collapse(true);
      },

      /**
       * create WrappedRange from node after position
       *
       * @param {Node} node
       * @return {WrappedRange}
       */
      createFromNodeAfter: function (node) {
        return this.createFromNode(node).collapse();
      },

      /**
       * @method
       *
       * create WrappedRange from bookmark
       *
       * @param {Node} editable
       * @param {Object} bookmark
       * @return {WrappedRange}
       */
      createFromBookmark: function (editable, bookmark) {
        var sc = dom.fromOffsetPath(editable, bookmark.s.path);
        var so = bookmark.s.offset;
        var ec = dom.fromOffsetPath(editable, bookmark.e.path);
        var eo = bookmark.e.offset;
        return new WrappedRange(sc, so, ec, eo);
      },

      /**
       * @method
       *
       * create WrappedRange from paraBookmark
       *
       * @param {Object} bookmark
       * @param {Node[]} paras
       * @return {WrappedRange}
       */
      createFromParaBookmark: function (bookmark, paras) {
        var so = bookmark.s.offset;
        var eo = bookmark.e.offset;
        var sc = dom.fromOffsetPath(list.head(paras), bookmark.s.path);
        var ec = dom.fromOffsetPath(list.last(paras), bookmark.e.path);

        return new WrappedRange(sc, so, ec, eo);
      }
    };
  })();

  /**
   * @class core.async
   *
   * Async functions which returns `Promise`
   *
   * @singleton
   * @alternateClassName async
   */
  var async = (function () {
    /**
     * @method readFileAsDataURL
     *
     * read contents of file as representing URL
     *
     * @param {File} file
     * @return {Promise} - then: dataUrl
     */
    var readFileAsDataURL = function (file) {
      return $.Deferred(function (deferred) {
        $.extend(new FileReader(), {
          onload: function (e) {
            var dataURL = e.target.result;
            deferred.resolve(dataURL);
          },
          onerror: function () {
            deferred.reject(this);
          }
        }).readAsDataURL(file);
      }).promise();
    };

    /**
     * @method createImage
     *
     * create `<image>` from url string
     *
     * @param {String} url
     * @return {Promise} - then: $image
     */
    var createImage = function (url) {
      return $.Deferred(function (deferred) {
        var $img = $('<img>');

        $img.one('load', function () {
          $img.off('error abort');
          deferred.resolve($img);
        }).one('error abort', function () {
          $img.off('load').detach();
          deferred.reject($img);
        }).css({
          display: 'none'
        }).appendTo(document.body).attr('src', url);
      }).promise();
    };

    return {
      readFileAsDataURL: readFileAsDataURL,
      createImage: createImage
    };
  })();

  /**
   * @class editing.History
   *
   * Editor History
   *
   */
  var History = function ($editable) {
    var stack = [], stackOffset = -1;
    var editable = $editable[0];

    var makeSnapshot = function () {
      var rng = range.create();
      var emptyBookmark = {s: {path: [], offset: 0}, e: {path: [], offset: 0}};

      return {
        contents: $editable.html(),
        bookmark: (rng ? rng.bookmark(editable) : emptyBookmark)
      };
    };

    var applySnapshot = function (snapshot) {
      if (snapshot.contents !== null) {
        $editable.html(snapshot.contents);
      }
      if (snapshot.bookmark !== null) {
        range.createFromBookmark(editable, snapshot.bookmark).select();
      }
    };

    /**
    * @method rewind
    * Rewinds the history stack back to the first snapshot taken.
    * Leaves the stack intact, so that "Redo" can still be used.
    */
    this.rewind = function () {

      // Create snap shot if not yet recorded
      if ($editable.html() !== stack[stackOffset].contents) {
        this.recordUndo();
      }

      // Return to the first available snapshot.
      stackOffset = 0;

      // Apply that snapshot.
      applySnapshot(stack[stackOffset]);

    };


    /**
    * @method reset
    * Resets the history stack completely; reverting to an empty editor.
    */
    this.reset = function () {

      // Clear the stack.
      stack = [];

      // Restore stackOffset to its original value.
      stackOffset = -1;

      // Clear the editable area.
      $editable.html('');

      // Record our first snapshot (of nothing).
      this.recordUndo();

    };

    /**
     * undo
     */
    this.undo = function () {
      // Create snap shot if not yet recorded
      if ($editable.html() !== stack[stackOffset].contents) {
        this.recordUndo();
      }

      if (0 < stackOffset) {
        stackOffset--;
        applySnapshot(stack[stackOffset]);
      }
    };

    /**
     * redo
     */
    this.redo = function () {
      if (stack.length - 1 > stackOffset) {
        stackOffset++;
        applySnapshot(stack[stackOffset]);
      }
    };

    /**
     * recorded undo
     */
    this.recordUndo = function () {
      stackOffset++;

      // Wash out stack after stackOffset
      if (stack.length > stackOffset) {
        stack = stack.slice(0, stackOffset);
      }

      // Create new snapshot and push it to the end
      stack.push(makeSnapshot());
    };
  };

  /**
   * @class editing.Style
   *
   * Style
   *
   */
  var Style = function () {
    /**
     * @method jQueryCSS
     *
     * [workaround] for old jQuery
     * passing an array of style properties to .css()
     * will result in an object of property-value pairs.
     * (compability with version < 1.9)
     *
     * @private
     * @param  {jQuery} $obj
     * @param  {Array} propertyNames - An array of one or more CSS properties.
     * @return {Object}
     */
    var jQueryCSS = function ($obj, propertyNames) {
      if (agent.jqueryVersion < 1.9) {
        var result = {};
        $.each(propertyNames, function (idx, propertyName) {
          result[propertyName] = $obj.css(propertyName);
        });
        return result;
      }
      return $obj.css.call($obj, propertyNames);
    };

    /**
     * returns style object from node
     *
     * @param {jQuery} $node
     * @return {Object}
     */
    this.fromNode = function ($node) {
      var properties = ['font-family', 'font-size', 'text-align', 'list-style-type', 'line-height'];
      var styleInfo = jQueryCSS($node, properties) || {};
      styleInfo['font-size'] = parseInt(styleInfo['font-size'], 10);
      return styleInfo;
    };

    /**
     * paragraph level style
     *
     * @param {WrappedRange} rng
     * @param {Object} styleInfo
     */
    this.stylePara = function (rng, styleInfo) {
      $.each(rng.nodes(dom.isPara, {
        includeAncestor: true
      }), function (idx, para) {
        $(para).css(styleInfo);
      });
    };

    /**
     * insert and returns styleNodes on range.
     *
     * @param {WrappedRange} rng
     * @param {Object} [options] - options for styleNodes
     * @param {String} [options.nodeName] - default: `SPAN`
     * @param {Boolean} [options.expandClosestSibling] - default: `false`
     * @param {Boolean} [options.onlyPartialContains] - default: `false`
     * @return {Node[]}
     */
    this.styleNodes = function (rng, options) {
      rng = rng.splitText();

      var nodeName = options && options.nodeName || 'SPAN';
      var expandClosestSibling = !!(options && options.expandClosestSibling);
      var onlyPartialContains = !!(options && options.onlyPartialContains);

      if (rng.isCollapsed()) {
        return [rng.insertNode(dom.create(nodeName))];
      }

      var pred = dom.makePredByNodeName(nodeName);
      var nodes = rng.nodes(dom.isText, {
        fullyContains: true
      }).map(function (text) {
        return dom.singleChildAncestor(text, pred) || dom.wrap(text, nodeName);
      });

      if (expandClosestSibling) {
        if (onlyPartialContains) {
          var nodesInRange = rng.nodes();
          // compose with partial contains predication
          pred = func.and(pred, function (node) {
            return list.contains(nodesInRange, node);
          });
        }

        return nodes.map(function (node) {
          var siblings = dom.withClosestSiblings(node, pred);
          var head = list.head(siblings);
          var tails = list.tail(siblings);
          $.each(tails, function (idx, elem) {
            dom.appendChildNodes(head, elem.childNodes);
            dom.remove(elem);
          });
          return list.head(siblings);
        });
      } else {
        return nodes;
      }
    };

    /**
     * get current style on cursor
     *
     * @param {WrappedRange} rng
     * @return {Object} - object contains style properties.
     */
    this.current = function (rng) {
      var $cont = $(!dom.isElement(rng.sc) ? rng.sc.parentNode : rng.sc);
      var styleInfo = this.fromNode($cont);

      // document.queryCommandState for toggle state
      // [workaround] prevent Firefox nsresult: "0x80004005 (NS_ERROR_FAILURE)"
      try {
        styleInfo = $.extend(styleInfo, {
          'font-bold': document.queryCommandState('bold') ? 'bold' : 'normal',
          'font-italic': document.queryCommandState('italic') ? 'italic' : 'normal',
          'font-underline': document.queryCommandState('underline') ? 'underline' : 'normal',
          'font-subscript': document.queryCommandState('subscript') ? 'subscript' : 'normal',
          'font-superscript': document.queryCommandState('superscript') ? 'superscript' : 'normal',
          'font-strikethrough': document.queryCommandState('strikethrough') ? 'strikethrough' : 'normal'
        });
      } catch (e) {}

      // list-style-type to list-style(unordered, ordered)
      if (!rng.isOnList()) {
        styleInfo['list-style'] = 'none';
      } else {
        var orderedTypes = ['circle', 'disc', 'disc-leading-zero', 'square'];
        var isUnordered = $.inArray(styleInfo['list-style-type'], orderedTypes) > -1;
        styleInfo['list-style'] = isUnordered ? 'unordered' : 'ordered';
      }

      var para = dom.ancestor(rng.sc, dom.isPara);
      if (para && para.style['line-height']) {
        styleInfo['line-height'] = para.style.lineHeight;
      } else {
        var lineHeight = parseInt(styleInfo['line-height'], 10) / parseInt(styleInfo['font-size'], 10);
        styleInfo['line-height'] = lineHeight.toFixed(1);
      }

      styleInfo.anchor = rng.isOnAnchor() && dom.ancestor(rng.sc, dom.isAnchor);
      styleInfo.ancestors = dom.listAncestor(rng.sc, dom.isEditable);
      styleInfo.range = rng;

      return styleInfo;
    };
  };


  /**
   * @class editing.Bullet
   *
   * @alternateClassName Bullet
   */
  var Bullet = function () {
    /**
     * @method insertOrderedList
     *
     * toggle ordered list
     *
     * @type command
     */
    this.insertOrderedList = function () {
      this.toggleList('OL');
    };

    /**
     * @method insertUnorderedList
     *
     * toggle unordered list
     *
     * @type command
     */
    this.insertUnorderedList = function () {
      this.toggleList('UL');
    };

    /**
     * @method indent
     *
     * indent
     *
     * @type command
     */
    this.indent = function () {
      var self = this;
      var rng = range.create().wrapBodyInlineWithPara();

      var paras = rng.nodes(dom.isPara, { includeAncestor: true });
      var clustereds = list.clusterBy(paras, func.peq2('parentNode'));

      $.each(clustereds, function (idx, paras) {
        var head = list.head(paras);
        if (dom.isLi(head)) {
          self.wrapList(paras, head.parentNode.nodeName);
        } else {
          $.each(paras, function (idx, para) {
            $(para).css('marginLeft', function (idx, val) {
              return (parseInt(val, 10) || 0) + 25;
            });
          });
        }
      });

      rng.select();
    };

    /**
     * @method outdent
     *
     * outdent
     *
     * @type command
     */
    this.outdent = function () {
      var self = this;
      var rng = range.create().wrapBodyInlineWithPara();

      var paras = rng.nodes(dom.isPara, { includeAncestor: true });
      var clustereds = list.clusterBy(paras, func.peq2('parentNode'));

      $.each(clustereds, function (idx, paras) {
        var head = list.head(paras);
        if (dom.isLi(head)) {
          self.releaseList([paras]);
        } else {
          $.each(paras, function (idx, para) {
            $(para).css('marginLeft', function (idx, val) {
              val = (parseInt(val, 10) || 0);
              return val > 25 ? val - 25 : '';
            });
          });
        }
      });

      rng.select();
    };

    /**
     * @method toggleList
     *
     * toggle list
     *
     * @param {String} listName - OL or UL
     */
    this.toggleList = function (listName) {
      var self = this;
      var rng = range.create().wrapBodyInlineWithPara();

      var paras = rng.nodes(dom.isPara, { includeAncestor: true });
      var bookmark = rng.paraBookmark(paras);
      var clustereds = list.clusterBy(paras, func.peq2('parentNode'));

      // paragraph to list
      if (list.find(paras, dom.isPurePara)) {
        var wrappedParas = [];
        $.each(clustereds, function (idx, paras) {
          wrappedParas = wrappedParas.concat(self.wrapList(paras, listName));
        });
        paras = wrappedParas;
      // list to paragraph or change list style
      } else {
        var diffLists = rng.nodes(dom.isList, {
          includeAncestor: true
        }).filter(function (listNode) {
          return !$.nodeName(listNode, listName);
        });

        if (diffLists.length) {
          $.each(diffLists, function (idx, listNode) {
            dom.replace(listNode, listName);
          });
        } else {
          paras = this.releaseList(clustereds, true);
        }
      }

      range.createFromParaBookmark(bookmark, paras).select();
    };

    /**
     * @method wrapList
     *
     * @param {Node[]} paras
     * @param {String} listName
     * @return {Node[]}
     */
    this.wrapList = function (paras, listName) {
      var head = list.head(paras);
      var last = list.last(paras);

      var prevList = dom.isList(head.previousSibling) && head.previousSibling;
      var nextList = dom.isList(last.nextSibling) && last.nextSibling;

      var listNode = prevList || dom.insertAfter(dom.create(listName || 'UL'), last);

      // P to LI
      paras = paras.map(function (para) {
        return dom.isPurePara(para) ? dom.replace(para, 'LI') : para;
      });

      // append to list(<ul>, <ol>)
      dom.appendChildNodes(listNode, paras);

      if (nextList) {
        dom.appendChildNodes(listNode, list.from(nextList.childNodes));
        dom.remove(nextList);
      }

      return paras;
    };

    /**
     * @method releaseList
     *
     * @param {Array[]} clustereds
     * @param {Boolean} isEscapseToBody
     * @return {Node[]}
     */
    this.releaseList = function (clustereds, isEscapseToBody) {
      var releasedParas = [];

      $.each(clustereds, function (idx, paras) {
        var head = list.head(paras);
        var last = list.last(paras);

        var headList = isEscapseToBody ? dom.lastAncestor(head, dom.isList) :
                                         head.parentNode;
        var lastList = headList.childNodes.length > 1 ? dom.splitTree(headList, {
          node: last.parentNode,
          offset: dom.position(last) + 1
        }, {
          isSkipPaddingBlankHTML: true
        }) : null;

        var middleList = dom.splitTree(headList, {
          node: head.parentNode,
          offset: dom.position(head)
        }, {
          isSkipPaddingBlankHTML: true
        });

        paras = isEscapseToBody ? dom.listDescendant(middleList, dom.isLi) :
                                  list.from(middleList.childNodes).filter(dom.isLi);

        // LI to P
        if (isEscapseToBody || !dom.isList(headList.parentNode)) {
          paras = paras.map(function (para) {
            return dom.replace(para, 'P');
          });
        }

        $.each(list.from(paras).reverse(), function (idx, para) {
          dom.insertAfter(para, headList);
        });

        // remove empty lists
        var rootLists = list.compact([headList, middleList, lastList]);
        $.each(rootLists, function (idx, rootList) {
          var listNodes = [rootList].concat(dom.listDescendant(rootList, dom.isList));
          $.each(listNodes.reverse(), function (idx, listNode) {
            if (!dom.nodeLength(listNode)) {
              dom.remove(listNode, true);
            }
          });
        });

        releasedParas = releasedParas.concat(paras);
      });

      return releasedParas;
    };
  };


  /**
   * @class editing.Typing
   *
   * Typing
   *
   */
  var Typing = function () {

    // a Bullet instance to toggle lists off
    var bullet = new Bullet();

    /**
     * insert tab
     *
     * @param {jQuery} $editable
     * @param {WrappedRange} rng
     * @param {Number} tabsize
     */
    this.insertTab = function ($editable, rng, tabsize) {
      var tab = dom.createText(new Array(tabsize + 1).join(dom.NBSP_CHAR));
      rng = rng.deleteContents();
      rng.insertNode(tab, true);

      rng = range.create(tab, tabsize);
      rng.select();
    };

    /**
     * insert paragraph
     */
    this.insertParagraph = function ($editable) {
      var rng = range.create();

      // deleteContents on range.
      rng = rng.deleteContents();

      // Wrap range if it needs to be wrapped by paragraph
      rng = rng.wrapBodyInlineWithPara();

      // finding paragraph
      var splitRoot = dom.ancestor(rng.sc, dom.isPara);

      var nextPara;
      // on paragraph: split paragraph
      if (splitRoot) {
        // if it is an empty line with li
        if (dom.isEmpty(splitRoot) && dom.isLi(splitRoot)) {
          // toogle UL/OL and escape
          bullet.toggleList(splitRoot.parentNode.nodeName);
          return;
        // if it is an empty line with para on blockquote
        } else if (dom.isEmpty(splitRoot) && dom.isPara(splitRoot) && dom.isBlockquote(splitRoot.parentNode)) {
          // escape blockquote
          dom.insertAfter(splitRoot, splitRoot.parentNode);
          nextPara = splitRoot;
        // if new line has content (not a line break)
        } else {
          nextPara = dom.splitTree(splitRoot, rng.getStartPoint());

          var emptyAnchors = dom.listDescendant(splitRoot, dom.isEmptyAnchor);
          emptyAnchors = emptyAnchors.concat(dom.listDescendant(nextPara, dom.isEmptyAnchor));

          $.each(emptyAnchors, function (idx, anchor) {
            dom.remove(anchor);
          });

          // replace empty heading or pre with P tag
          if ((dom.isHeading(nextPara) || dom.isPre(nextPara)) && dom.isEmpty(nextPara)) {
            nextPara = dom.replace(nextPara, 'p');
          }
        }
      // no paragraph: insert empty paragraph
      } else {
        var next = rng.sc.childNodes[rng.so];
        nextPara = $(dom.emptyPara)[0];
        if (next) {
          rng.sc.insertBefore(nextPara, next);
        } else {
          rng.sc.appendChild(nextPara);
        }
      }

      range.create(nextPara, 0).normalize().select().scrollIntoView($editable);
    };
  };

  /**
   * @class editing.Table
   *
   * Table
   *
   */
  var Table = function () {
    /**
     * handle tab key
     *
     * @param {WrappedRange} rng
     * @param {Boolean} isShift
     */
    this.tab = function (rng, isShift) {
      var cell = dom.ancestor(rng.commonAncestor(), dom.isCell);
      var table = dom.ancestor(cell, dom.isTable);
      var cells = dom.listDescendant(table, dom.isCell);

      var nextCell = list[isShift ? 'prev' : 'next'](cells, cell);
      if (nextCell) {
        range.create(nextCell, 0).select();
      }
    };

    /**
     * create empty table element
     *
     * @param {Number} rowCount
     * @param {Number} colCount
     * @return {Node}
     */
    this.createTable = function (colCount, rowCount, options) {
      var tds = [], tdHTML;
      for (var idxCol = 0; idxCol < colCount; idxCol++) {
        tds.push('<td>' + dom.blank + '</td>');
      }
      tdHTML = tds.join('');

      var trs = [], trHTML;
      for (var idxRow = 0; idxRow < rowCount; idxRow++) {
        trs.push('<tr>' + tdHTML + '</tr>');
      }
      trHTML = trs.join('');
      var $table = $('<table>' + trHTML + '</table>');
      if (options && options.tableClassName) {
        $table.addClass(options.tableClassName);
      }

      return $table[0];
    };
  };


  var KEY_BOGUS = 'bogus';

  /**
   * @class Editor
   */
  var Editor = function (context) {
    var self = this;

    var $note = context.layoutInfo.note;
    var $editor = context.layoutInfo.editor;
    var $editable = context.layoutInfo.editable;
    var options = context.options;
    var lang = options.langInfo;

    var style = new Style();
    var table = new Table();
    var typing = new Typing();
    var bullet = new Bullet();
    var history = new History($editable);

    this.initialize = function () {
      // bind custom events
      $editable.on('keydown', function (event) {
        if (event.keyCode === key.code.ENTER) {
          context.triggerEvent('enter', event);
        }
        context.triggerEvent('keydown', event);

        if (options.shortcuts && !event.isDefaultPrevented()) {
          self.handleKeyMap(event);
        }
      }).on('keyup', function (event) {
        context.triggerEvent('keyup', event);
      }).on('focus', function (event) {
        context.triggerEvent('focus', event);
      }).on('blur', function (event) {
        context.triggerEvent('blur', event);
      }).on('mousedown', function (event) {
        context.triggerEvent('mousedown', event);
      }).on('mouseup', function (event) {
        context.triggerEvent('mouseup', event);
      }).on('scroll', function (event) {
        context.triggerEvent('scroll', event);
      }).on('paste', function (event) {
        context.triggerEvent('paste', event);
      });

      // [workaround] IE doesn't have input events for contentEditable
      // - see: https://goo.gl/4bfIvA
      var changeEventName = agent.isMSIE ? 'DOMCharacterDataModified DOMSubtreeModified DOMNodeInserted' : 'input';
      $editable.on(changeEventName, function () {
        context.triggerEvent('change', $editable.html());
      });

      $editor.on('focusin', function (event) {
        context.triggerEvent('focusin', event);
      }).on('focusout', function (event) {
        context.triggerEvent('focusout', event);
      });

      if (!options.airMode && options.height) {
        $editable.outerHeight(options.height);
      }
      if (!options.airMode && options.maxHeight) {
        $editable.css('max-height', options.maxHeight);
      }
      if (!options.airMode && options.minHeight) {
        $editable.css('min-height', options.minHeight);
      }

      $editable.html(dom.html($note) || dom.emptyPara);
      history.recordUndo();
    };

    this.destroy = function () {
      $editable.off();
    };

    this.handleKeyMap = function (event) {
      var keyMap = options.keyMap[agent.isMac ? 'mac' : 'pc'];
      var keys = [];

      if (event.metaKey) { keys.push('CMD'); }
      if (event.ctrlKey && !event.altKey) { keys.push('CTRL'); }
      if (event.shiftKey) { keys.push('SHIFT'); }

      var keyName = key.nameFromCode[event.keyCode];
      if (keyName) {
        keys.push(keyName);
      }

      var eventName = keyMap[keys.join('+')];
      if (eventName) {
        event.preventDefault();
        context.invoke(eventName);
      } else if (key.isEdit(event.keyCode)) {
        this.afterCommand();
      }
    };

    /**
     * createRange
     *
     * create range
     * @return {WrappedRange}
     */
    this.createRange = function () {
      this.focus();
      return range.create();
    };

    /**
     * saveRange
     *
     * save current range
     *
     * @param {Boolean} [thenCollapse=false]
     */
    this.saveRange = function (thenCollapse) {
      this.focus();
      $editable.data('range', range.create());
      if (thenCollapse) {
        range.create().collapse().select();
      }
    };

    /**
     * restoreRange
     *
     * restore lately range
     */
    this.restoreRange = function () {
      var rng = $editable.data('range');
      if (rng) {
        rng.select();
        this.focus();
      }
    };

    this.saveTarget = function (node) {
      $editable.data('target', node);
    };

    this.clearTarget = function () {
      $editable.removeData('target');
    };

    this.restoreTarget = function () {
      return $editable.data('target');
    };

    /**
     * currentStyle
     *
     * current style
     * @return {Object|Boolean} unfocus
     */
    this.currentStyle = function () {
      var rng = range.create();
      if (rng) {
        rng = rng.normalize();
      }
      return rng ? style.current(rng) : style.fromNode($editable);
    };

    /**
     * style from node
     *
     * @param {jQuery} $node
     * @return {Object}
     */
    this.styleFromNode = function ($node) {
      return style.fromNode($node);
    };

    /**
     * undo
     */
    this.undo = function () {
      context.triggerEvent('before.command', $editable.html());
      history.undo();
      context.triggerEvent('change', $editable.html());
    };
    context.memo('help.undo', lang.help.undo);

    /**
     * redo
     */
    this.redo = function () {
      context.triggerEvent('before.command', $editable.html());
      history.redo();
      context.triggerEvent('change', $editable.html());
    };
    context.memo('help.redo', lang.help.redo);

    /**
     * beforeCommand
     * before command
     */
    var beforeCommand = this.beforeCommand = function () {
      context.triggerEvent('before.command', $editable.html());
      // keep focus on editable before command execution
      self.focus();
    };

    /**
     * afterCommand
     * after command
     * @param {Boolean} isPreventTrigger
     */
    var afterCommand = this.afterCommand = function (isPreventTrigger) {
      history.recordUndo();
      if (!isPreventTrigger) {
        context.triggerEvent('change', $editable.html());
      }
    };

    /* jshint ignore:start */
    // native commands(with execCommand), generate function for execCommand
    var commands = ['bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript',
                    'justifyLeft', 'justifyCenter', 'justifyRight', 'justifyFull',
                    'formatBlock', 'removeFormat',
                    'backColor', 'foreColor', 'fontName'];

    for (var idx = 0, len = commands.length; idx < len; idx ++) {
      this[commands[idx]] = (function (sCmd) {
        return function (value) {
          beforeCommand();
          document.execCommand(sCmd, false, value);
          afterCommand(true);
        };
      })(commands[idx]);
      context.memo('help.' + commands[idx], lang.help[commands[idx]]);
    }
    /* jshint ignore:end */

    /**
     * tab
     *
     * handle tab key
     */
    this.tab = function () {
      var rng = this.createRange();
      if (rng.isCollapsed() && rng.isOnCell()) {
        table.tab(rng);
      } else {
        beforeCommand();
        typing.insertTab($editable, rng, options.tabSize);
        afterCommand();
      }
    };
    context.memo('help.tab', lang.help.tab);

    /**
     * untab
     *
     * handle shift+tab key
     *
     */
    this.untab = function () {
      var rng = this.createRange();
      if (rng.isCollapsed() && rng.isOnCell()) {
        table.tab(rng, true);
      }
    };
    context.memo('help.untab', lang.help.untab);

    /**
     * wrapCommand
     *
     * run given function between beforeCommand and afterCommand
     */
    this.wrapCommand = function (fn) {
      return function () {
        beforeCommand();
        fn.apply(self, arguments);
        afterCommand();
      };
    };

    /**
     * insertParagraph
     *
     * insert paragraph
     */
    this.insertParagraph = this.wrapCommand(function () {
      typing.insertParagraph($editable);
    });
    context.memo('help.insertParagraph', lang.help.insertParagraph);

    /**
     * insertOrderedList
     */
    this.insertOrderedList = this.wrapCommand(function () {
      bullet.insertOrderedList($editable);
    });
    context.memo('help.insertOrderedList', lang.help.insertOrderedList);

    this.insertUnorderedList = this.wrapCommand(function () {
      bullet.insertUnorderedList($editable);
    });
    context.memo('help.insertUnorderedList', lang.help.insertUnorderedList);

    this.indent = this.wrapCommand(function () {
      bullet.indent($editable);
    });
    context.memo('help.indent', lang.help.indent);

    this.outdent = this.wrapCommand(function () {
      bullet.outdent($editable);
    });
    context.memo('help.outdent', lang.help.outdent);

    /**
     * insert image
     *
     * @param {String} src
     * @param {String|Function} param
     * @return {Promise}
     */
    this.insertImage = function (src, param) {
      return async.createImage(src, param).then(function ($image) {
        beforeCommand();

        if (typeof param === 'function') {
          param($image);
        } else {
          if (typeof param === 'string') {
            $image.attr('data-filename', param);
          }
          $image.css('width', Math.min($editable.width(), $image.width()));
        }

        $image.show();
        range.create().insertNode($image[0]);
        range.createFromNodeAfter($image[0]).select();
        afterCommand();
      }).fail(function () {
        context.triggerEvent('image.upload.error');
      });
    };

    /**
     * insertImages
     * @param {File[]} files
     */
    this.insertImages = function (files) {
      $.each(files, function (idx, file) {
        var filename = file.name;
        if (options.maximumImageFileSize && options.maximumImageFileSize < file.size) {
          context.triggerEvent('image.upload.error', lang.image.maximumFileSizeError);
        } else {
          async.readFileAsDataURL(file).then(function (dataURL) {
            return self.insertImage(dataURL, filename);
          }).fail(function () {
            context.triggerEvent('image.upload.error');
          });
        }
      });
    };

    /**
     * insertImagesOrCallback
     * @param {File[]} files
     */
    this.insertImagesOrCallback = function (files) {
      var callbacks = options.callbacks;

      // If onImageUpload options setted
      if (callbacks.onImageUpload) {
        context.triggerEvent('image.upload', files);
      // else insert Image as dataURL
      } else {
        this.insertImages(files);
      }
    };

    /**
     * insertNode
     * insert node
     * @param {Node} node
     */
    this.insertNode = this.wrapCommand(function (node) {
      range.create().insertNode(node);
      range.createFromNodeAfter(node).select();
    });

    /**
     * insert text
     * @param {String} text
     */
    this.insertText = this.wrapCommand(function (text) {
      var textNode = range.create().insertNode(dom.createText(text));
      range.create(textNode, dom.nodeLength(textNode)).select();
    });

    /**
     * return selected plain text
     * @return {String} text
     */
    this.getSelectedText = function () {
      var rng = this.createRange();

      // if range on anchor, expand range with anchor
      if (rng.isOnAnchor()) {
        rng = range.createFromNode(dom.ancestor(rng.sc, dom.isAnchor));
      }

      return rng.toString();
    };

    /**
     * paste HTML
     * @param {String} markup
     */
    this.pasteHTML = this.wrapCommand(function (markup) {
      var contents = range.create().pasteHTML(markup);
      range.createFromNodeAfter(list.last(contents)).select();
    });

    /**
     * formatBlock
     *
     * @param {String} tagName
     */
    this.formatBlock = this.wrapCommand(function (tagName) {
      // [workaround] for MSIE, IE need `<`
      tagName = agent.isMSIE ? '<' + tagName + '>' : tagName;
      document.execCommand('FormatBlock', false, tagName);
    });

    this.formatPara = function () {
      this.formatBlock('P');
    };
    context.memo('help.formatPara', lang.help.formatPara);

    /* jshint ignore:start */
    for (var idx = 1; idx <= 6; idx ++) {
      this['formatH' + idx] = function (idx) {
        return function () {
          this.formatBlock('H' + idx);
        };
      }(idx);
      context.memo('help.formatH'+idx, lang.help['formatH' + idx]);
    };
    /* jshint ignore:end */


    /**
     * fontSize
     *
     * @param {String} value - px
     */
    this.fontSize = function (value) {
      this.focus();
      var rng = range.create();

      if (rng && rng.isCollapsed()) {
        var spans = style.styleNodes(rng);
        var firstSpan = list.head(spans);

        $(spans).css({
          'font-size': value + 'px'
        });

        // [workaround] added styled bogus span for style
        //  - also bogus character needed for cursor position
        if (firstSpan && !dom.nodeLength(firstSpan)) {
          firstSpan.innerHTML = dom.ZERO_WIDTH_NBSP_CHAR;
          range.createFromNodeAfter(firstSpan.firstChild).select();
          $editable.data(KEY_BOGUS, firstSpan);
        }
      } else {
        beforeCommand();
        $(style.styleNodes(rng)).css({
          'font-size': value + 'px'
        });
        afterCommand();
      }
    };

    /**
     * insert horizontal rule
     */
    this.insertHorizontalRule = this.wrapCommand(function () {
      var rng = range.create();
      var hrNode = rng.insertNode($('<HR/>')[0]);
      if (hrNode.nextSibling) {
        range.create(hrNode.nextSibling, 0).normalize().select();
      }
    });
    context.memo('help.insertHorizontalRule', lang.help.insertHorizontalRule);


    /**
     * remove bogus node and character
     */
    this.removeBogus = function () {
      var bogusNode = $editable.data(KEY_BOGUS);
      if (!bogusNode) {
        return;
      }

      var textNode = list.find(list.from(bogusNode.childNodes), dom.isText);

      var bogusCharIdx = textNode.nodeValue.indexOf(dom.ZERO_WIDTH_NBSP_CHAR);
      if (bogusCharIdx !== -1) {
        textNode.deleteData(bogusCharIdx, 1);
      }

      if (dom.isEmpty(bogusNode)) {
        dom.remove(bogusNode);
      }

      $editable.removeData(KEY_BOGUS);
    };

    /**
     * lineHeight
     * @param {String} value
     */
    this.lineHeight = this.wrapCommand(function (value) {
      style.stylePara(range.create(), {
        lineHeight: value
      });
    });

    /**
     * unlink
     *
     * @type command
     */
    this.unlink = function () {
      var rng = this.createRange();
      if (rng.isOnAnchor()) {
        var anchor = dom.ancestor(rng.sc, dom.isAnchor);
        rng = range.createFromNode(anchor);
        rng.select();

        beforeCommand();
        document.execCommand('unlink');
        afterCommand();
      }
    };

    /**
     * create link (command)
     *
     * @param {Object} linkInfo
     */
    this.createLink = this.wrapCommand(function (linkInfo) {
      var linkUrl = linkInfo.url;
      var linkText = linkInfo.text;
      var isNewWindow = linkInfo.isNewWindow;
      var rng = linkInfo.range || this.createRange();
      var isTextChanged = rng.toString() !== linkText;

      if (options.onCreateLink) {
        linkUrl = options.onCreateLink(linkUrl);
      }

      var anchors = [];
      if (isTextChanged) {
        // Create a new link when text changed.
        var anchor = rng.insertNode($('<A>' + linkText + '</A>')[0]);
        anchors.push(anchor);
      } else {
        anchors = style.styleNodes(rng, {
          nodeName: 'A',
          expandClosestSibling: true,
          onlyPartialContains: true
        });
      }

      $.each(anchors, function (idx, anchor) {
        $(anchor).attr('href', linkUrl);
        if (isNewWindow) {
          $(anchor).attr('target', '_blank');
        } else {
          $(anchor).removeAttr('target');
        }
      });

      var startRange = range.createFromNodeBefore(list.head(anchors));
      var startPoint = startRange.getStartPoint();
      var endRange = range.createFromNodeAfter(list.last(anchors));
      var endPoint = endRange.getEndPoint();

      range.create(
        startPoint.node,
        startPoint.offset,
        endPoint.node,
        endPoint.offset
      ).select();
    });

    /**
     * returns link info
     *
     * @return {Object}
     * @return {WrappedRange} return.range
     * @return {String} return.text
     * @return {Boolean} [return.isNewWindow=true]
     * @return {String} [return.url=""]
     */
    this.getLinkInfo = function () {
      this.focus();

      var rng = range.create().expand(dom.isAnchor);

      // Get the first anchor on range(for edit).
      var $anchor = $(list.head(rng.nodes(dom.isAnchor)));

      return {
        range: rng,
        text: rng.toString(),
        isNewWindow: $anchor.length ? $anchor.attr('target') === '_blank' : false,
        url: $anchor.length ? $anchor.attr('href') : ''
      };
    };

    /**
     * setting color
     *
     * @param {Object} sObjColor  color code
     * @param {String} sObjColor.foreColor foreground color
     * @param {String} sObjColor.backColor background color
     */
    this.color = this.wrapCommand(function (colorInfo) {
      var foreColor = colorInfo.foreColor;
      var backColor = colorInfo.backColor;

      if (foreColor) { document.execCommand('foreColor', false, foreColor); }
      if (backColor) { document.execCommand('backColor', false, backColor); }
    });

    /**
     * insert Table
     *
     * @param {String} sDim dimension of table (ex : "5x5")
     */
    this.insertTable = this.wrapCommand(function (sDim) {
      var dimension = sDim.split('x');

      var rng = range.create().deleteContents();
      rng.insertNode(table.createTable(dimension[0], dimension[1], options));
    });

    /**
     * float me
     *
     * @param {String} value
     */
    this.floatMe = this.wrapCommand(function (value) {
      var $target = $(this.restoreTarget());
      $target.css('float', value);
    });

    /**
     * resize overlay element
     * @param {String} value
     */
    this.resize = this.wrapCommand(function (value) {
      var $target = $(this.restoreTarget());
      $target.css({
        width: value * 100 + '%',
        height: ''
      });
    });

    /**
     * @param {Position} pos
     * @param {jQuery} $target - target element
     * @param {Boolean} [bKeepRatio] - keep ratio
     */
    this.resizeTo = function (pos, $target, bKeepRatio) {
      var imageSize;
      if (bKeepRatio) {
        var newRatio = pos.y / pos.x;
        var ratio = $target.data('ratio');
        imageSize = {
          width: ratio > newRatio ? pos.x : pos.y / ratio,
          height: ratio > newRatio ? pos.x * ratio : pos.y
        };
      } else {
        imageSize = {
          width: pos.x,
          height: pos.y
        };
      }

      $target.css(imageSize);
    };

    /**
     * remove media object
     */
    this.removeMedia = this.wrapCommand(function () {
      var $target = $(this.restoreTarget()).detach();
      context.triggerEvent('media.delete', $target, $editable);
    });

    /**
     * returns whether editable area has focus or not.
     */
    this.hasFocus = function () {
      return $editable.is(':focus');
    };

    /**
     * set focus
     */
    this.focus = function () {
      // [workaround] Screen will move when page is scolled in IE.
      //  - do focus when not focused
      if (!this.hasFocus()) {
        $editable.focus();

        // [workaround] for firefox bug http://goo.gl/lVfAaI
        if (!this.hasFocus() && agent.isFF) {
          range.createFromNode($editable[0])
               .normalize()
               .collapse()
               .select();
        }
      }
    };

    /**
     * returns whether contents is empty or not.
     * @return {Boolean}
     */
    this.isEmpty = function () {
      return dom.isEmpty($editable[0]) || dom.emptyPara === $editable.html();
    };

    /**
     * Removes all contents and restores the editable instance to an _emptyPara_.
     */
    this.empty = function () {
      context.invoke('code', dom.emptyPara);
    };
  };

  var Clipboard = function (context) {
    var self = this;

    var $editable = context.layoutInfo.editable;

    this.events = {
      'summernote.keydown': function (we, e) {
        if (self.needKeydownHook()) {
          if ((e.ctrlKey || e.metaKey) && e.keyCode === key.code.V) {
            context.invoke('editor.saveRange');
            self.$paste.focus();

            setTimeout(function () {
              self.pasteByHook();
            }, 0);
          }
        }
      }
    };

    this.needKeydownHook = function () {
      return (agent.isMSIE && agent.browserVersion > 10) || agent.isFF;
    };

    this.initialize = function () {
      // [workaround] getting image from clipboard
      //  - IE11 and Firefox: CTRL+v hook
      //  - Webkit: event.clipboardData
      if (this.needKeydownHook()) {
        this.$paste = $('<div />').attr('contenteditable', true).css({
          position: 'absolute',
          left: -100000,
          opacity: 0
        });
        $editable.before(this.$paste);

        this.$paste.on('paste', function (event) {
          context.triggerEvent('paste', event);
        });
      } else {
        $editable.on('paste', this.pasteByEvent);
      }
    };

    this.destroy = function () {
      if (this.needKeydownHook()) {
        this.$paste.remove();
        this.$paste = null;
      }
    };

    this.pasteByHook = function () {
      var node = this.$paste[0].firstChild;

      if (dom.isImg(node)) {
        var dataURI = node.src;
        var decodedData = atob(dataURI.split(',')[1]);
        var array = new Uint8Array(decodedData.length);
        for (var i = 0; i < decodedData.length; i++) {
          array[i] = decodedData.charCodeAt(i);
        }

        var blob = new Blob([array], { type: 'image/png' });
        blob.name = 'clipboard.png';

        context.invoke('editor.restoreRange');
        context.invoke('editor.focus');
        context.invoke('editor.insertImagesOrCallback', [blob]);
      } else {
        var pasteContent = $('<div />').html(this.$paste.html()).html();
        context.invoke('editor.restoreRange');
        context.invoke('editor.focus');

        if (pasteContent) {
          context.invoke('editor.pasteHTML', pasteContent);
        }
      }

      this.$paste.empty();
    };

    /**
     * paste by clipboard event
     *
     * @param {Event} event
     */
    this.pasteByEvent = function (event) {
      var clipboardData = event.originalEvent.clipboardData;
      if (clipboardData && clipboardData.items && clipboardData.items.length) {
        var item = list.head(clipboardData.items);
        if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
          context.invoke('editor.insertImagesOrCallback', [item.getAsFile()]);
        }
        context.invoke('editor.afterCommand');
      }
    };
  };

  var Dropzone = function (context) {
    var $document = $(document);
    var $editor = context.layoutInfo.editor;
    var $editable = context.layoutInfo.editable;
    var options = context.options;
    var lang = options.langInfo;

    var $dropzone = $([
      '<div class="note-dropzone">',
      '  <div class="note-dropzone-message"/>',
      '</div>'
    ].join('')).prependTo($editor);

    /**
     * attach Drag and Drop Events
     */
    this.initialize = function () {
      if (options.disableDragAndDrop) {
        // prevent default drop event
        $document.on('drop', function (e) {
          e.preventDefault();
        });
      } else {
        this.attachDragAndDropEvent();
      }
    };

    /**
     * attach Drag and Drop Events
     */
    this.attachDragAndDropEvent = function () {
      var collection = $(),
          $dropzoneMessage = $dropzone.find('.note-dropzone-message');

      // show dropzone on dragenter when dragging a object to document
      // -but only if the editor is visible, i.e. has a positive width and height
      $document.on('dragenter', function (e) {
        var isCodeview = context.invoke('codeview.isActivated');
        var hasEditorSize = $editor.width() > 0 && $editor.height() > 0;
        if (!isCodeview && !collection.length && hasEditorSize) {
          $editor.addClass('dragover');
          $dropzone.width($editor.width());
          $dropzone.height($editor.height());
          $dropzoneMessage.text(lang.image.dragImageHere);
        }
        collection = collection.add(e.target);
      }).on('dragleave', function (e) {
        collection = collection.not(e.target);
        if (!collection.length) {
          $editor.removeClass('dragover');
        }
      }).on('drop', function () {
        collection = $();
        $editor.removeClass('dragover');
      });

      // change dropzone's message on hover.
      $dropzone.on('dragenter', function () {
        $dropzone.addClass('hover');
        $dropzoneMessage.text(lang.image.dropImage);
      }).on('dragleave', function () {
        $dropzone.removeClass('hover');
        $dropzoneMessage.text(lang.image.dragImageHere);
      });

      // attach dropImage
      $dropzone.on('drop', function (event) {
        var dataTransfer = event.originalEvent.dataTransfer;

        if (dataTransfer && dataTransfer.files && dataTransfer.files.length) {
          event.preventDefault();
          $editable.focus();
          context.invoke('editor.insertImagesOrCallback', dataTransfer.files);
        } else {
          $.each(dataTransfer.types, function (idx, type) {
            var content = dataTransfer.getData(type);

            if (type.toLowerCase().indexOf('text') > -1) {
              context.invoke('editor.pasteHTML', content);
            } else {
              $(content).each(function () {
                context.invoke('editor.insertNode', this);
              });
            }
          });
        }
      }).on('dragover', false); // prevent default dragover event
    };
  };


  var CodeMirror;
  if (agent.hasCodeMirror) {
    if (agent.isSupportAmd) {
      require(['codemirror'], function (cm) {
        CodeMirror = cm;
      });
    } else {
      CodeMirror = window.CodeMirror;
    }
  }

  /**
   * @class Codeview
   */
  var Codeview = function (context) {
    var $editor = context.layoutInfo.editor;
    var $editable = context.layoutInfo.editable;
    var $codable = context.layoutInfo.codable;
    var options = context.options;

    this.sync = function () {
      var isCodeview = this.isActivated();
      if (isCodeview && agent.hasCodeMirror) {
        $codable.data('cmEditor').save();
      }
    };

    /**
     * @return {Boolean}
     */
    this.isActivated = function () {
      return $editor.hasClass('codeview');
    };

    /**
     * toggle codeview
     */
    this.toggle = function () {
      if (this.isActivated()) {
        this.deactivate();
      } else {
        this.activate();
      }
      context.triggerEvent('codeview.toggled');
    };

    /**
     * activate code view
     */
    this.activate = function () {
      $codable.val(dom.html($editable, options.prettifyHtml));
      $codable.height($editable.height());

      context.invoke('toolbar.updateCodeview', true);
      $editor.addClass('codeview');
      $codable.focus();

      // activate CodeMirror as codable
      if (agent.hasCodeMirror) {
        var cmEditor = CodeMirror.fromTextArea($codable[0], options.codemirror);

        // CodeMirror TernServer
        if (options.codemirror.tern) {
          var server = new CodeMirror.TernServer(options.codemirror.tern);
          cmEditor.ternServer = server;
          cmEditor.on('cursorActivity', function (cm) {
            server.updateArgHints(cm);
          });
        }

        // CodeMirror hasn't Padding.
        cmEditor.setSize(null, $editable.outerHeight());
        $codable.data('cmEditor', cmEditor);
      }
    };

    /**
     * deactivate code view
     */
    this.deactivate = function () {
      // deactivate CodeMirror as codable
      if (agent.hasCodeMirror) {
        var cmEditor = $codable.data('cmEditor');
        $codable.val(cmEditor.getValue());
        cmEditor.toTextArea();
      }

      var value = dom.value($codable, options.prettifyHtml) || dom.emptyPara;
      var isChange = $editable.html() !== value;

      $editable.html(value);
      $editable.height(options.height ? $codable.height() : 'auto');
      $editor.removeClass('codeview');

      if (isChange) {
        context.triggerEvent('change', $editable.html(), $editable);
      }

      $editable.focus();

      context.invoke('toolbar.updateCodeview', false);
    };

    this.destroy = function () {
      if (this.isActivated()) {
        this.deactivate();
      }
    };
  };

  var EDITABLE_PADDING = 24;

  var Statusbar = function (context) {
    var $document = $(document);
    var $statusbar = context.layoutInfo.statusbar;
    var $editable = context.layoutInfo.editable;
    var options = context.options;

    this.initialize = function () {
      if (options.airMode || options.disableResizeEditor) {
        return;
      }

      $statusbar.on('mousedown', function (event) {
        event.preventDefault();
        event.stopPropagation();

        var editableTop = $editable.offset().top - $document.scrollTop();

        $document.on('mousemove', function (event) {
          var height = event.clientY - (editableTop + EDITABLE_PADDING);

          height = (options.minheight > 0) ? Math.max(height, options.minheight) : height;
          height = (options.maxHeight > 0) ? Math.min(height, options.maxHeight) : height;

          $editable.height(height);
        }).one('mouseup', function () {
          $document.off('mousemove');
        });
      });
    };

    this.destroy = function () {
      $statusbar.off();
    };
  };

  var Fullscreen = function (context) {
    var $editor = context.layoutInfo.editor;
    var $toolbar = context.layoutInfo.toolbar;
    var $editable = context.layoutInfo.editable;
    var $codable = context.layoutInfo.codable;

    var $window = $(window);
    var $scrollbar = $('html, body');

    /**
     * toggle fullscreen
     */
    this.toggle = function () {
      var resize = function (size) {
        $editable.css('height', size.h);
        $codable.css('height', size.h);
        if ($codable.data('cmeditor')) {
          $codable.data('cmeditor').setsize(null, size.h);
        }
      };

      $editor.toggleClass('fullscreen');
      var isFullscreen = $editor.hasClass('fullscreen');
      if (isFullscreen) {
        $editable.data('orgHeight', $editable.css('height'));

        $window.on('resize', function () {
          resize({
            h: $window.height() - $toolbar.outerHeight()
          });
        }).trigger('resize');

        $scrollbar.css('overflow', 'hidden');
      } else {
        $window.off('resize');
        resize({
          h: $editable.data('orgHeight')
        });
        $scrollbar.css('overflow', 'visible');
      }

      context.invoke('toolbar.updateFullscreen', isFullscreen);
    };
  };

  var Handle = function (context) {
    var self = this;

    var $document = $(document);
    var $editingArea = context.layoutInfo.editingArea;
    var options = context.options;

    this.events = {
      'summernote.mousedown': function (we, e) {
        if (self.update(e.target)) {
          e.preventDefault();
        }
      },
      'summernote.keyup summernote.scroll summernote.change summernote.dialog.shown': function () {
        self.update();
      }
    };

    this.initialize = function () {
      this.$handle = $([
        '<div class="note-handle">',
        '<div class="note-control-selection">',
        '<div class="note-control-selection-bg"></div>',
        '<div class="note-control-holder note-control-nw"></div>',
        '<div class="note-control-holder note-control-ne"></div>',
        '<div class="note-control-holder note-control-sw"></div>',
        '<div class="',
        (options.disableResizeImage ? 'note-control-holder' : 'note-control-sizing'),
        ' note-control-se"></div>',
        (options.disableResizeImage ? '' : '<div class="note-control-selection-info"></div>'),
        '</div>',
        '</div>'
      ].join('')).prependTo($editingArea);

      this.$handle.on('mousedown', function (event) {
        if (dom.isControlSizing(event.target)) {
          event.preventDefault();
          event.stopPropagation();

          var $target = self.$handle.find('.note-control-selection').data('target'),
              posStart = $target.offset(),
              scrollTop = $document.scrollTop();

          $document.on('mousemove', function (event) {
            context.invoke('editor.resizeTo', {
              x: event.clientX - posStart.left,
              y: event.clientY - (posStart.top - scrollTop)
            }, $target, !event.shiftKey);

            self.update($target[0]);
          }).one('mouseup', function (e) {
            e.preventDefault();
            $document.off('mousemove');
            context.invoke('editor.afterCommand');
          });

          if (!$target.data('ratio')) { // original ratio.
            $target.data('ratio', $target.height() / $target.width());
          }
        }
      });
    };

    this.destroy = function () {
      this.$handle.remove();
    };

    this.update = function (target) {
      var isImage = dom.isImg(target);
      var $selection = this.$handle.find('.note-control-selection');

      context.invoke('imagePopover.update', target);

      if (isImage) {
        var $image = $(target);
        var pos = $image.position();

        // include margin
        var imageSize = {
          w: $image.outerWidth(true),
          h: $image.outerHeight(true)
        };

        $selection.css({
          display: 'block',
          left: pos.left,
          top: pos.top,
          width: imageSize.w,
          height: imageSize.h
        }).data('target', $image); // save current image element.

        var sizingText = imageSize.w + 'x' + imageSize.h;
        $selection.find('.note-control-selection-info').text(sizingText);
        context.invoke('editor.saveTarget', target);
      } else {
        this.hide();
      }

      return isImage;
    };

    /**
     * hide
     *
     * @param {jQuery} $handle
     */
    this.hide = function () {
      context.invoke('editor.clearTarget');
      this.$handle.children().hide();
    };
  };

  var AutoLink = function (context) {
    var self = this;
    var defaultScheme = 'http://';
    var linkPattern = /^(https?:\/\/|ssh:\/\/|ftp:\/\/|file:\/|mailto:[A-Z0-9._%+-]+@)?(www\.)?(.+)$/i;

    this.events = {
      'summernote.keyup': function (we, e) {
        if (!e.isDefaultPrevented()) {
          self.handleKeyup(e);
        }
      },
      'summernote.keydown': function (we, e) {
        self.handleKeydown(e);
      }
    };

    this.initialize = function () {
      this.lastWordRange = null;
    };

    this.destroy = function () {
      this.lastWordRange = null;
    };

    this.replace = function () {
      if (!this.lastWordRange) {
        return;
      }

      var keyword = this.lastWordRange.toString();
      var match = keyword.match(linkPattern);

      if (match && (match[1] || match[2])) {
        var link = match[1] ? keyword : defaultScheme + keyword;
        var node = $('<a />').html(keyword).attr('href', link)[0];

        this.lastWordRange.insertNode(node);
        this.lastWordRange = null;
        context.invoke('editor.focus');
      }

    };

    this.handleKeydown = function (e) {
      if (list.contains([key.code.ENTER, key.code.SPACE], e.keyCode)) {
        var wordRange = context.invoke('editor.createRange').getWordRange();
        this.lastWordRange = wordRange;
      }
    };

    this.handleKeyup = function (e) {
      if (list.contains([key.code.ENTER, key.code.SPACE], e.keyCode)) {
        this.replace();
      }
    };
  };

  /**
   * textarea auto sync.
   */
  var AutoSync = function (context) {
    var $note = context.layoutInfo.note;

    this.events = {
      'summernote.change': function () {
        $note.val(context.invoke('code'));
      }
    };

    this.shouldInitialize = function () {
      return dom.isTextarea($note[0]);
    };
  };

  var Placeholder = function (context) {
    var self = this;
    var $editingArea = context.layoutInfo.editingArea;
    var options = context.options;

    this.events = {
      'summernote.init summernote.change': function () {
        self.update();
      },
      'summernote.codeview.toggled': function () {
        self.update();
      }
    };

    this.shouldInitialize = function () {
      return !!options.placeholder;
    };

    this.initialize = function () {
      this.$placeholder = $('<div class="note-placeholder">');
      this.$placeholder.on('click', function () {
        context.invoke('focus');
      }).text(options.placeholder).prependTo($editingArea);
    };

    this.destroy = function () {
      this.$placeholder.remove();
    };

    this.update = function () {
      var isShow = !context.invoke('codeview.isActivated') && context.invoke('editor.isEmpty');
      this.$placeholder.toggle(isShow);
    };
  };

  var Buttons = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var $toolbar = context.layoutInfo.toolbar;
    var options = context.options;
    var lang = options.langInfo;

    var invertedKeyMap = func.invertObject(options.keyMap[agent.isMac ? 'mac' : 'pc']);

    var representShortcut = this.representShortcut = function (editorMethod) {
      var shortcut = invertedKeyMap[editorMethod];
      if (agent.isMac) {
        shortcut = shortcut.replace('CMD', '⌘').replace('SHIFT', '⇧');
      }

      shortcut = shortcut.replace('BACKSLASH', '\\')
                         .replace('SLASH', '/')
                         .replace('LEFTBRACKET', '[')
                         .replace('RIGHTBRACKET', ']');

      return ' (' + shortcut + ')';
    };

    this.initialize = function () {
      this.addToolbarButtons();
      this.addImagePopoverButtons();
      this.addLinkPopoverButtons();
    };

    this.addToolbarButtons = function () {
      context.memo('button.style', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: ui.icon(options.icons.magic) + ' ' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.style.style,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdown({
            className: 'dropdown-style',
            items: context.options.styleTags,
            template: function (item) {

              if (typeof item === 'string') {
                item = { tag: item, title: item };
              }

              var tag = item.tag;
              var title = item.title;
              var style = item.style ? ' style="' + item.style + '" ' : '';
              var className = item.className ? ' className="' + item.className + '"' : '';

              return '<' + tag + style + className + '>' + title + '</' + tag +  '>';
            },
            click: context.createInvokeHandler('editor.formatBlock')
          })
        ]).render();
      });

      context.memo('button.bold', function () {
        return ui.button({
          className: 'note-btn-bold',
          contents: ui.icon(options.icons.bold),
          tooltip: lang.font.bold + representShortcut('bold'),
          click: context.createInvokeHandler('editor.bold')
        }).render();
      });

      context.memo('button.italic', function () {
        return ui.button({
          className: 'note-btn-italic',
          contents: ui.icon(options.icons.italic),
          tooltip: lang.font.italic + representShortcut('italic'),
          click: context.createInvokeHandler('editor.italic')
        }).render();
      });

      context.memo('button.underline', function () {
        return ui.button({
          className: 'note-btn-underline',
          contents: ui.icon(options.icons.underline),
          tooltip: lang.font.underline + representShortcut('underline'),
          click: context.createInvokeHandler('editor.underline')
        }).render();
      });

      context.memo('button.clear', function () {
        return ui.button({
          contents: ui.icon(options.icons.eraser),
          tooltip: lang.font.clear + representShortcut('removeFormat'),
          click: context.createInvokeHandler('editor.removeFormat')
        }).render();
      });

      context.memo('button.strikethrough', function () {
        return ui.button({
          className: 'note-btn-strikethrough',
          contents: ui.icon(options.icons.strikethrough),
          tooltip: lang.font.strikethrough + representShortcut('strikethrough'),
          click: context.createInvokeHandler('editor.strikethrough')
        }).render();
      });

      context.memo('button.superscript', function () {
        return ui.button({
          className: 'note-btn-superscript',
          contents: ui.icon(options.icons.superscript),
          tooltip: lang.font.superscript,
          click: context.createInvokeHandler('editor.superscript')
        }).render();
      });

      context.memo('button.subscript', function () {
        return ui.button({
          className: 'note-btn-subscript',
          contents: ui.icon(options.icons.subscript),
          tooltip: lang.font.subscript,
          click: context.createInvokeHandler('editor.subscript')
        }).render();
      });

      context.memo('button.fontname', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: '<span class="note-current-fontname"/> ' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.font.name,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdownCheck({
            className: 'dropdown-fontname',
            checkClassName: options.icons.menuCheck,
            items: options.fontNames.filter(function (name) {
              return agent.isFontInstalled(name) ||
                list.contains(options.fontNamesIgnoreCheck, name);
            }),
            template: function (item) {
              return '<span style="font-family:' + item + '">' + item + '</span>';
            },
            click: context.createInvokeHandler('editor.fontName')
          })
        ]).render();
      });

      context.memo('button.fontsize', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: '<span class="note-current-fontsize"/>' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.font.size,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdownCheck({
            className: 'dropdown-fontsize',
            checkClassName: options.icons.menuCheck,
            items: options.fontSizes,
            click: context.createInvokeHandler('editor.fontSize')
          })
        ]).render();
      });

      context.memo('button.color', function () {
        return ui.buttonGroup({
          className: 'note-color',
          children: [
            ui.button({
              className: 'note-current-color-button',
              contents: ui.icon(options.icons.font + ' note-recent-color'),
              tooltip: lang.color.recent,
              click: context.createInvokeHandler('editor.color'),
              callback: function ($button) {
                var $recentColor = $button.find('.note-recent-color');
                $recentColor.css({
                  'background-color': 'yellow'
                });

                $button.data('value', {
                  backColor: 'yellow'
                });
              }
            }),
            ui.button({
              className: 'dropdown-toggle',
              contents: ui.icon(options.icons.caret, 'span'),
              tooltip: lang.color.more,
              data: {
                toggle: 'dropdown'
              }
            }),
            ui.dropdown({
              items: [
                '<li>',
                '<div class="btn-group">',
                '  <div class="note-palette-title">' + lang.color.background + '</div>',
                '  <div>',
                '    <button type="button" class="note-color-reset btn btn-default" data-event="backColor" data-value="inherit">',
                lang.color.transparent,
                '    </button>',
                '  </div>',
                '  <div class="note-holder" data-event="backColor"/>',
                '</div>',
                '<div class="btn-group">',
                '  <div class="note-palette-title">' + lang.color.foreground + '</div>',
                '  <div>',
                '    <button type="button" class="note-color-reset btn btn-default" data-event="removeFormat" data-value="foreColor">',
                lang.color.resetToDefault,
                '    </button>',
                '  </div>',
                '  <div class="note-holder" data-event="foreColor"/>',
                '</div>',
                '</li>'
              ].join(''),
              callback: function ($dropdown) {
                $dropdown.find('.note-holder').each(function () {
                  var $holder = $(this);
                  $holder.append(ui.palette({
                    colors: options.colors,
                    eventName: $holder.data('event')
                  }).render());
                });
              },
              click: function (event) {
                var $button = $(event.target);
                var eventName = $button.data('event');
                var value = $button.data('value');

                if (eventName && value) {
                  var key = eventName === 'backColor' ? 'background-color' : 'color';
                  var $color = $button.closest('.note-color').find('.note-recent-color');
                  var $currentButton = $button.closest('.note-color').find('.note-current-color-button');

                  var colorInfo = $currentButton.data('value');
                  colorInfo[eventName] = value;
                  $color.css(key, value);
                  $currentButton.data('value', colorInfo);

                  context.invoke('editor.' + eventName, value);
                }
              }
            })
          ]
        }).render();
      });

      context.memo('button.ol',  function () {
        return ui.button({
          contents: ui.icon(options.icons.unorderedlist),
          tooltip: lang.lists.unordered + representShortcut('insertUnorderedList'),
          click: context.createInvokeHandler('editor.insertUnorderedList')
        }).render();
      });

      context.memo('button.ul', function () {
        return ui.button({
          contents: ui.icon(options.icons.orderedlist),
          tooltip: lang.lists.ordered + representShortcut('insertOrderedList'),
          click:  context.createInvokeHandler('editor.insertOrderedList')
        }).render();
      });

      var justifyLeft = ui.button({
        contents: ui.icon(options.icons.alignLeft),
        tooltip: lang.paragraph.left + representShortcut('justifyLeft'),
        click: context.createInvokeHandler('editor.justifyLeft')
      });

      var justifyCenter = ui.button({
        contents: ui.icon(options.icons.alignCenter),
        tooltip: lang.paragraph.center + representShortcut('justifyCenter'),
        click: context.createInvokeHandler('editor.justifyCenter')
      });

      var justifyRight = ui.button({
        contents: ui.icon(options.icons.alignRight),
        tooltip: lang.paragraph.right + representShortcut('justifyRight'),
        click: context.createInvokeHandler('editor.justifyRight')
      });

      var justifyFull = ui.button({
        contents: ui.icon(options.icons.alignJustify),
        tooltip: lang.paragraph.justify + representShortcut('justifyFull'),
        click: context.createInvokeHandler('editor.justifyFull')
      });

      var outdent = ui.button({
        contents: ui.icon(options.icons.outdent),
        tooltip: lang.paragraph.outdent + representShortcut('outdent'),
        click: context.createInvokeHandler('editor.outdent')
      });

      var indent = ui.button({
        contents: ui.icon(options.icons.indent),
        tooltip: lang.paragraph.indent + representShortcut('indent'),
        click: context.createInvokeHandler('editor.indent')
      });

      context.memo('button.justifyLeft', func.invoke(justifyLeft, 'render'));
      context.memo('button.justifyCenter', func.invoke(justifyCenter, 'render'));
      context.memo('button.justifyRight', func.invoke(justifyRight, 'render'));
      context.memo('button.justifyFull', func.invoke(justifyFull, 'render'));
      context.memo('button.outdent', func.invoke(outdent, 'render'));
      context.memo('button.indent', func.invoke(indent, 'render'));

      context.memo('button.paragraph', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: ui.icon(options.icons.align) + ' ' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.paragraph.paragraph,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdown([
            ui.buttonGroup({
              className: 'note-align',
              children: [justifyLeft, justifyCenter, justifyRight, justifyFull]
            }),
            ui.buttonGroup({
              className: 'note-list',
              children: [outdent, indent]
            })
          ])
        ]).render();
      });

      context.memo('button.height', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: ui.icon(options.icons.textHeight) + ' ' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.font.height,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdownCheck({
            items: options.lineHeights,
            checkClassName: options.icons.menuCheck,
            className: 'dropdown-line-height',
            click: context.createInvokeHandler('editor.lineHeight')
          })
        ]).render();
      });

      context.memo('button.table', function () {
        return ui.buttonGroup([
          ui.button({
            className: 'dropdown-toggle',
            contents: ui.icon(options.icons.table) + ' ' + ui.icon(options.icons.caret, 'span'),
            tooltip: lang.table.table,
            data: {
              toggle: 'dropdown'
            }
          }),
          ui.dropdown({
            className: 'note-table',
            items: [
              '<div class="note-dimension-picker">',
              '  <div class="note-dimension-picker-mousecatcher" data-event="insertTable" data-value="1x1"/>',
              '  <div class="note-dimension-picker-highlighted"/>',
              '  <div class="note-dimension-picker-unhighlighted"/>',
              '</div>',
              '<div class="note-dimension-display">1 x 1</div>'
            ].join('')
          })
        ], {
          callback: function ($node) {
            var $catcher = $node.find('.note-dimension-picker-mousecatcher');
            $catcher.css({
              width: options.insertTableMaxSize.col + 'em',
              height: options.insertTableMaxSize.row + 'em'
            }).mousedown(context.createInvokeHandler('editor.insertTable'))
              .on('mousemove', self.tableMoveHandler);
          }
        }).render();
      });

      context.memo('button.link', function () {
        return ui.button({
          contents: ui.icon(options.icons.link),
          tooltip: lang.link.link,
          click: context.createInvokeHandler('linkDialog.show')
        }).render();
      });

      context.memo('button.picture', function () {
        return ui.button({
          contents: ui.icon(options.icons.picture),
          tooltip: lang.image.image,
          click: context.createInvokeHandler('imageDialog.show')
        }).render();
      });

      context.memo('button.video', function () {
        return ui.button({
          contents: ui.icon(options.icons.video),
          tooltip: lang.video.video,
          click: context.createInvokeHandler('videoDialog.show')
        }).render();
      });

      context.memo('button.hr', function () {
        return ui.button({
          contents: ui.icon(options.icons.minus),
          tooltip: lang.hr.insert + representShortcut('insertHorizontalRule'),
          click: context.createInvokeHandler('editor.insertHorizontalRule')
        }).render();
      });

      context.memo('button.fullscreen', function () {
        return ui.button({
          className: 'btn-fullscreen',
          contents: ui.icon(options.icons.arrowsAlt),
          tooltip: lang.options.fullscreen,
          click: context.createInvokeHandler('fullscreen.toggle')
        }).render();
      });

      context.memo('button.codeview', function () {
        return ui.button({
          className: 'btn-codeview',
          contents: ui.icon(options.icons.code),
          tooltip: lang.options.codeview,
          click: context.createInvokeHandler('codeview.toggle')
        }).render();
      });

      context.memo('button.redo', function () {
        return ui.button({
          contents: ui.icon(options.icons.redo),
          tooltip: lang.history.redo + representShortcut('redo'),
          click: context.createInvokeHandler('editor.redo')
        }).render();
      });

      context.memo('button.undo', function () {
        return ui.button({
          contents: ui.icon(options.icons.undo),
          tooltip: lang.history.undo + representShortcut('undo'),
          click: context.createInvokeHandler('editor.undo')
        }).render();
      });

      context.memo('button.help', function () {
        return ui.button({
          contents: ui.icon(options.icons.question),
          tooltip: lang.options.help,
          click: context.createInvokeHandler('helpDialog.show')
        }).render();
      });
    };

    /**
     * image : [
     *   ['imagesize', ['imageSize100', 'imageSize50', 'imageSize25']],
     *   ['float', ['floatLeft', 'floatRight', 'floatNone' ]],
     *   ['remove', ['removeMedia']]
     * ],
     */
    this.addImagePopoverButtons = function () {
      // Image Size Buttons
      context.memo('button.imageSize100', function () {
        return ui.button({
          contents: '<span class="note-fontsize-10">100%</span>',
          tooltip: lang.image.resizeFull,
          click: context.createInvokeHandler('editor.resize', '1')
        }).render();
      });
      context.memo('button.imageSize50', function () {
        return  ui.button({
          contents: '<span class="note-fontsize-10">50%</span>',
          tooltip: lang.image.resizeHalf,
          click: context.createInvokeHandler('editor.resize', '0.5')
        }).render();
      });
      context.memo('button.imageSize25', function () {
        return ui.button({
          contents: '<span class="note-fontsize-10">25%</span>',
          tooltip: lang.image.resizeQuarter,
          click: context.createInvokeHandler('editor.resize', '0.25')
        }).render();
      });

      // Float Buttons
      context.memo('button.floatLeft', function () {
        return ui.button({
          contents: ui.icon(options.icons.alignLeft),
          tooltip: lang.image.floatLeft,
          click: context.createInvokeHandler('editor.floatMe', 'left')
        }).render();
      });

      context.memo('button.floatRight', function () {
        return ui.button({
          contents: ui.icon(options.icons.alignRight),
          tooltip: lang.image.floatRight,
          click: context.createInvokeHandler('editor.floatMe', 'right')
        }).render();
      });

      context.memo('button.floatNone', function () {
        return ui.button({
          contents: ui.icon(options.icons.alignJustify),
          tooltip: lang.image.floatNone,
          click: context.createInvokeHandler('editor.floatMe', 'none')
        }).render();
      });

      // Remove Buttons
      context.memo('button.removeMedia', function () {
        return ui.button({
          contents: ui.icon(options.icons.trash),
          tooltip: lang.image.remove,
          click: context.createInvokeHandler('editor.removeMedia')
        }).render();
      });
    };

    this.addLinkPopoverButtons = function () {
      context.memo('button.linkDialogShow', function () {
        return ui.button({
          contents: ui.icon(options.icons.link),
          tooltip: lang.link.edit,
          click: context.createInvokeHandler('linkDialog.show')
        }).render();
      });

      context.memo('button.unlink', function () {
        return ui.button({
          contents: ui.icon(options.icons.unlink),
          tooltip: lang.link.unlink,
          click: context.createInvokeHandler('editor.unlink')
        }).render();
      });
    };

    this.build = function ($container, groups) {
      for (var groupIdx = 0, groupLen = groups.length; groupIdx < groupLen; groupIdx++) {
        var group = groups[groupIdx];
        var groupName = group[0];
        var buttons = group[1];

        var $group = ui.buttonGroup({
          className: 'note-' + groupName
        }).render();

        for (var idx = 0, len = buttons.length; idx < len; idx++) {
          var button = context.memo('button.' + buttons[idx]);
          if (button) {
            $group.append(typeof button === 'function' ? button() : button);
          }
        }
        $group.appendTo($container);
      }
    };

    this.updateCurrentStyle = function () {
      var styleInfo = context.invoke('editor.currentStyle');
      this.updateBtnStates({
        '.note-btn-bold': function () {
          return styleInfo['font-bold'] === 'bold';
        },
        '.note-btn-italic': function () {
          return styleInfo['font-italic'] === 'italic';
        },
        '.note-btn-underline': function () {
          return styleInfo['font-underline'] === 'underline';
        },
        '.note-btn-subscript': function () {
          return styleInfo['font-subscript'] === 'subscript';
        },
        '.note-btn-superscript': function () {
          return styleInfo['font-superscript'] === 'superscript';
        },
        '.note-btn-strikethrough': function () {
          return styleInfo['font-strikethrough'] === 'strikethrough';
        }
      });

      if (styleInfo['font-family']) {
        var fontNames = styleInfo['font-family'].split(',').map(function (name) {
          return name.replace(/[\'\"]/g, '')
            .replace(/\s+$/, '')
            .replace(/^\s+/, '');
        });
        var fontName = list.find(fontNames, function (name) {
          return agent.isFontInstalled(name) ||
            list.contains(options.fontNamesIgnoreCheck, name);
        });

        $toolbar.find('.dropdown-fontname li a').each(function () {
          // always compare string to avoid creating another func.
          var isChecked = ($(this).data('value') + '') === (fontName + '');
          this.className = isChecked ? 'checked' : '';
        });
        $toolbar.find('.note-current-fontname').text(fontName);
      }

      if (styleInfo['font-size']) {
        var fontSize = styleInfo['font-size'];
        $toolbar.find('.dropdown-fontsize li a').each(function () {
          // always compare with string to avoid creating another func.
          var isChecked = ($(this).data('value') + '') === (fontSize + '');
          this.className = isChecked ? 'checked' : '';
        });
        $toolbar.find('.note-current-fontsize').text(fontSize);
      }

      if (styleInfo['line-height']) {
        var lineHeight = styleInfo['line-height'];
        $toolbar.find('.dropdown-line-height li a').each(function () {
          // always compare with string to avoid creating another func.
          var isChecked = ($(this).data('value') + '') === (lineHeight + '');
          this.className = isChecked ? 'checked' : '';
        });
      }
    };

    this.updateBtnStates = function (infos) {
      $.each(infos, function (selector, pred) {
        ui.toggleBtnActive($toolbar.find(selector), pred());
      });
    };

    this.tableMoveHandler = function (event) {
      var PX_PER_EM = 18;
      var $picker = $(event.target.parentNode); // target is mousecatcher
      var $dimensionDisplay = $picker.next();
      var $catcher = $picker.find('.note-dimension-picker-mousecatcher');
      var $highlighted = $picker.find('.note-dimension-picker-highlighted');
      var $unhighlighted = $picker.find('.note-dimension-picker-unhighlighted');

      var posOffset;
      // HTML5 with jQuery - e.offsetX is undefined in Firefox
      if (event.offsetX === undefined) {
        var posCatcher = $(event.target).offset();
        posOffset = {
          x: event.pageX - posCatcher.left,
          y: event.pageY - posCatcher.top
        };
      } else {
        posOffset = {
          x: event.offsetX,
          y: event.offsetY
        };
      }

      var dim = {
        c: Math.ceil(posOffset.x / PX_PER_EM) || 1,
        r: Math.ceil(posOffset.y / PX_PER_EM) || 1
      };

      $highlighted.css({ width: dim.c + 'em', height: dim.r + 'em' });
      $catcher.data('value', dim.c + 'x' + dim.r);

      if (3 < dim.c && dim.c < options.insertTableMaxSize.col) {
        $unhighlighted.css({ width: dim.c + 1 + 'em'});
      }

      if (3 < dim.r && dim.r < options.insertTableMaxSize.row) {
        $unhighlighted.css({ height: dim.r + 1 + 'em'});
      }

      $dimensionDisplay.html(dim.c + ' x ' + dim.r);
    };
  };

  var Toolbar = function (context) {
    var ui = $.summernote.ui;

    var $note = context.layoutInfo.note;
    var $toolbar = context.layoutInfo.toolbar;
    var options = context.options;

    this.shouldInitialize = function () {
      return !options.airMode;
    };

    this.initialize = function () {
      options.toolbar = options.toolbar || [];

      if (!options.toolbar.length) {
        $toolbar.hide();
      } else {
        context.invoke('buttons.build', $toolbar, options.toolbar);
      }

      if (options.toolbarContainer) {
        $toolbar.appendTo(options.toolbarContainer);
      }

      $note.on('summernote.keyup summernote.mouseup summernote.change', function () {
        context.invoke('buttons.updateCurrentStyle');
      });

      context.invoke('buttons.updateCurrentStyle');
    };

    this.destroy = function () {
      $toolbar.children().remove();
    };

    this.updateFullscreen = function (isFullscreen) {
      ui.toggleBtnActive($toolbar.find('.btn-fullscreen'), isFullscreen);
    };

    this.updateCodeview = function (isCodeview) {
      ui.toggleBtnActive($toolbar.find('.btn-codeview'), isCodeview);
      if (isCodeview) {
        this.deactivate();
      } else {
        this.activate();
      }
    };

    this.activate = function (isIncludeCodeview) {
      var $btn = $toolbar.find('button');
      if (!isIncludeCodeview) {
        $btn = $btn.not('.btn-codeview');
      }
      ui.toggleBtn($btn, true);
    };

    this.deactivate = function (isIncludeCodeview) {
      var $btn = $toolbar.find('button');
      if (!isIncludeCodeview) {
        $btn = $btn.not('.btn-codeview');
      }
      ui.toggleBtn($btn, false);
    };
  };

  var LinkDialog = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var $editor = context.layoutInfo.editor;
    var options = context.options;
    var lang = options.langInfo;

    this.initialize = function () {
      var $container = options.dialogsInBody ? $(document.body) : $editor;

      var body = '<div class="form-group">' +
                   '<label>' + lang.link.textToDisplay + '</label>' +
                   '<input class="note-link-text form-control" type="text" />' +
                 '</div>' +
                 '<div class="form-group">' +
                   '<label>' + lang.link.url + '</label>' +
                   '<input class="note-link-url form-control" type="text" value="http://" />' +
                 '</div>' +
                 (!options.disableLinkTarget ?
                   '<div class="checkbox">' +
                     '<label>' + '<input type="checkbox" checked> ' + lang.link.openInNewWindow + '</label>' +
                   '</div>' : ''
                 );
      var footer = '<button href="#" class="btn btn-primary note-link-btn disabled" disabled>' + lang.link.insert + '</button>';

      this.$dialog = ui.dialog({
        className: 'link-dialog',
        title: lang.link.insert,
        fade: options.dialogsFade,
        body: body,
        footer: footer
      }).render().appendTo($container);
    };

    this.destroy = function () {
      ui.hideDialog(this.$dialog);
      this.$dialog.remove();
    };

    this.bindEnterKey = function ($input, $btn) {
      $input.on('keypress', function (event) {
        if (event.keyCode === key.code.ENTER) {
          $btn.trigger('click');
        }
      });
    };

    /**
     * Show link dialog and set event handlers on dialog controls.
     *
     * @param {Object} linkInfo
     * @return {Promise}
     */
    this.showLinkDialog = function (linkInfo) {
      return $.Deferred(function (deferred) {
        var $linkText = self.$dialog.find('.note-link-text'),
        $linkUrl = self.$dialog.find('.note-link-url'),
        $linkBtn = self.$dialog.find('.note-link-btn'),
        $openInNewWindow = self.$dialog.find('input[type=checkbox]');

        ui.onDialogShown(self.$dialog, function () {
          context.triggerEvent('dialog.shown');

          $linkText.val(linkInfo.text);

          $linkText.on('input', function () {
            ui.toggleBtn($linkBtn, $linkText.val() && $linkUrl.val());
            // if linktext was modified by keyup,
            // stop cloning text from linkUrl
            linkInfo.text = $linkText.val();
          });

          // if no url was given, copy text to url
          if (!linkInfo.url) {
            linkInfo.url = linkInfo.text || 'http://';
            ui.toggleBtn($linkBtn, linkInfo.text);
          }

          $linkUrl.on('input', function () {
            ui.toggleBtn($linkBtn, $linkText.val() && $linkUrl.val());
            // display same link on `Text to display` input
            // when create a new link
            if (!linkInfo.text) {
              $linkText.val($linkUrl.val());
            }
          }).val(linkInfo.url).trigger('focus');

          self.bindEnterKey($linkUrl, $linkBtn);
          self.bindEnterKey($linkText, $linkBtn);

          $openInNewWindow.prop('checked', linkInfo.isNewWindow);

          $linkBtn.one('click', function (event) {
            event.preventDefault();

            deferred.resolve({
              range: linkInfo.range,
              url: $linkUrl.val(),
              text: $linkText.val(),
              isNewWindow: $openInNewWindow.is(':checked')
            });
            self.$dialog.modal('hide');
          });
        });

        ui.onDialogHidden(self.$dialog, function () {
          // detach events
          $linkText.off('input keypress');
          $linkUrl.off('input keypress');
          $linkBtn.off('click');

          if (deferred.state() === 'pending') {
            deferred.reject();
          }
        });

        ui.showDialog(self.$dialog);
      }).promise();
    };

    /**
     * @param {Object} layoutInfo
     */
    this.show = function () {
      var linkInfo = context.invoke('editor.getLinkInfo');

      context.invoke('editor.saveRange');
      this.showLinkDialog(linkInfo).then(function (linkInfo) {
        context.invoke('editor.restoreRange');
        context.invoke('editor.createLink', linkInfo);
      }).fail(function () {
        context.invoke('editor.restoreRange');
      });
    };
    context.memo('help.linkDialog.show', options.langInfo.help['linkDialog.show']);
  };

  var LinkPopover = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var options = context.options;

    this.events = {
      'summernote.keyup summernote.mouseup summernote.change summernote.scroll': function () {
        self.update();
      },
      'summernote.dialog.shown': function () {
        self.hide();
      }
    };

    this.shouldInitialize = function () {
      return !list.isEmpty(options.popover.link);
    };

    this.initialize = function () {
      this.$popover = ui.popover({
        className: 'note-link-popover',
        callback: function ($node) {
          var $content = $node.find('.popover-content');
          $content.prepend('<span><a target="_blank"></a>&nbsp;</span>');
        }
      }).render().appendTo('body');
      var $content = this.$popover.find('.popover-content');

      context.invoke('buttons.build', $content, options.popover.link);
    };

    this.destroy = function () {
      this.$popover.remove();
    };

    this.update = function () {
      // Prevent focusing on editable when invoke('code') is executed
      if (!context.invoke('editor.hasFocus')) {
        this.hide();
        return;
      }

      var rng = context.invoke('editor.createRange');
      if (rng.isCollapsed() && rng.isOnAnchor()) {
        var anchor = dom.ancestor(rng.sc, dom.isAnchor);
        var href = $(anchor).attr('href');
        this.$popover.find('a').attr('href', href).html(href);

        var pos = dom.posFromPlaceholder(anchor);
        this.$popover.css({
          display: 'block',
          left: pos.left,
          top: pos.top
        });
      } else {
        this.hide();
      }
    };

    this.hide = function () {
      this.$popover.hide();
    };
  };

  var ImageDialog = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var $editor = context.layoutInfo.editor;
    var options = context.options;
    var lang = options.langInfo;

    this.initialize = function () {
      var $container = options.dialogsInBody ? $(document.body) : $editor;

      var imageLimitation = '';
      if (options.maximumImageFileSize) {
        var unit = Math.floor(Math.log(options.maximumImageFileSize) / Math.log(1024));
        var readableSize = (options.maximumImageFileSize / Math.pow(1024, unit)).toFixed(2) * 1 +
                           ' ' + ' KMGTP'[unit] + 'B';
        imageLimitation = '<small>' + lang.image.maximumFileSize + ' : ' + readableSize + '</small>';
      }

      var body = '<div class="form-group note-group-select-from-files">' +
                   '<label>' + lang.image.selectFromFiles + '</label>' +
                   '<input class="note-image-input form-control" type="file" name="files" accept="image/*" multiple="multiple" />' +
                   imageLimitation +
                 '</div>' +
                 '<div class="form-group" style="overflow:auto;">' +
                   '<label>' + lang.image.url + '</label>' +
                   '<input class="note-image-url form-control col-md-12" type="text" />' +
                 '</div>';
      var footer = '<button href="#" class="btn btn-primary note-image-btn disabled" disabled>' + lang.image.insert + '</button>';

      this.$dialog = ui.dialog({
        title: lang.image.insert,
        fade: options.dialogsFade,
        body: body,
        footer: footer
      }).render().appendTo($container);
    };

    this.destroy = function () {
      ui.hideDialog(this.$dialog);
      this.$dialog.remove();
    };

    this.bindEnterKey = function ($input, $btn) {
      $input.on('keypress', function (event) {
        if (event.keyCode === key.code.ENTER) {
          $btn.trigger('click');
        }
      });
    };

    this.show = function () {
      context.invoke('editor.saveRange');
      this.showImageDialog().then(function (data) {
        // [workaround] hide dialog before restore range for IE range focus
        ui.hideDialog(self.$dialog);
        context.invoke('editor.restoreRange');

        if (typeof data === 'string') { // image url
          context.invoke('editor.insertImage', data);
        } else { // array of files
          context.invoke('editor.insertImagesOrCallback', data);
        }
      }).fail(function () {
        context.invoke('editor.restoreRange');
      });
    };

    /**
     * show image dialog
     *
     * @param {jQuery} $dialog
     * @return {Promise}
     */
    this.showImageDialog = function () {
      return $.Deferred(function (deferred) {
        var $imageInput = self.$dialog.find('.note-image-input'),
            $imageUrl = self.$dialog.find('.note-image-url'),
            $imageBtn = self.$dialog.find('.note-image-btn');

        ui.onDialogShown(self.$dialog, function () {
          context.triggerEvent('dialog.shown');

          // Cloning imageInput to clear element.
          $imageInput.replaceWith($imageInput.clone()
            .on('change', function () {
              deferred.resolve(this.files || this.value);
            })
            .val('')
          );

          $imageBtn.click(function (event) {
            event.preventDefault();

            deferred.resolve($imageUrl.val());
          });

          $imageUrl.on('keyup paste', function () {
            var url = $imageUrl.val();
            ui.toggleBtn($imageBtn, url);
          }).val('').trigger('focus');
          self.bindEnterKey($imageUrl, $imageBtn);
        });

        ui.onDialogHidden(self.$dialog, function () {
          $imageInput.off('change');
          $imageUrl.off('keyup paste keypress');
          $imageBtn.off('click');

          if (deferred.state() === 'pending') {
            deferred.reject();
          }
        });

        ui.showDialog(self.$dialog);
      });
    };
  };

  var ImagePopover = function (context) {
    var ui = $.summernote.ui;

    var options = context.options;

    this.shouldInitialize = function () {
      return !list.isEmpty(options.popover.image);
    };

    this.initialize = function () {
      this.$popover = ui.popover({
        className: 'note-image-popover'
      }).render().appendTo('body');
      var $content = this.$popover.find('.popover-content');

      context.invoke('buttons.build', $content, options.popover.image);
    };

    this.destroy = function () {
      this.$popover.remove();
    };

    this.update = function (target) {
      if (dom.isImg(target)) {
        var pos = dom.posFromPlaceholder(target);
        this.$popover.css({
          display: 'block',
          left: pos.left,
          top: pos.top
        });
      } else {
        this.hide();
      }
    };

    this.hide = function () {
      this.$popover.hide();
    };
  };

  var VideoDialog = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var $editor = context.layoutInfo.editor;
    var options = context.options;
    var lang = options.langInfo;

    this.initialize = function () {
      var $container = options.dialogsInBody ? $(document.body) : $editor;

      var body = '<div class="form-group row-fluid">' +
          '<label>' + lang.video.url + ' <small class="text-muted">' + lang.video.providers + '</small></label>' +
          '<input class="note-video-url form-control span12" type="text" />' +
          '</div>';
      var footer = '<button href="#" class="btn btn-primary note-video-btn disabled" disabled>' + lang.video.insert + '</button>';

      this.$dialog = ui.dialog({
        title: lang.video.insert,
        fade: options.dialogsFade,
        body: body,
        footer: footer
      }).render().appendTo($container);
    };

    this.destroy = function () {
      ui.hideDialog(this.$dialog);
      this.$dialog.remove();
    };

    this.bindEnterKey = function ($input, $btn) {
      $input.on('keypress', function (event) {
        if (event.keyCode === key.code.ENTER) {
          $btn.trigger('click');
        }
      });
    };

    this.createVideoNode = function (url) {
      // video url patterns(youtube, instagram, vimeo, dailymotion, youku, mp4, ogg, webm)
      var ytRegExp = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;
      var ytMatch = url.match(ytRegExp);

      var igRegExp = /\/\/instagram.com\/p\/(.[a-zA-Z0-9_-]*)/;
      var igMatch = url.match(igRegExp);

      var vRegExp = /\/\/vine.co\/v\/(.[a-zA-Z0-9]*)/;
      var vMatch = url.match(vRegExp);

      var vimRegExp = /\/\/(player.)?vimeo.com\/([a-z]*\/)*([0-9]{6,11})[?]?.*/;
      var vimMatch = url.match(vimRegExp);

      var dmRegExp = /.+dailymotion.com\/(video|hub)\/([^_]+)[^#]*(#video=([^_&]+))?/;
      var dmMatch = url.match(dmRegExp);

      var youkuRegExp = /\/\/v\.youku\.com\/v_show\/id_(\w+)=*\.html/;
      var youkuMatch = url.match(youkuRegExp);

      var mp4RegExp = /^.+.(mp4|m4v)$/;
      var mp4Match = url.match(mp4RegExp);

      var oggRegExp = /^.+.(ogg|ogv)$/;
      var oggMatch = url.match(oggRegExp);

      var webmRegExp = /^.+.(webm)$/;
      var webmMatch = url.match(webmRegExp);

      var $video;
      if (ytMatch && ytMatch[1].length === 11) {
        var youtubeId = ytMatch[1];
        $video = $('<iframe>')
            .attr('frameborder', 0)
            .attr('src', '//www.youtube.com/embed/' + youtubeId)
            .attr('width', '640').attr('height', '360');
      } else if (igMatch && igMatch[0].length) {
        $video = $('<iframe>')
            .attr('frameborder', 0)
            .attr('src', igMatch[0] + '/embed/')
            .attr('width', '612').attr('height', '710')
            .attr('scrolling', 'no')
            .attr('allowtransparency', 'true');
      } else if (vMatch && vMatch[0].length) {
        $video = $('<iframe>')
            .attr('frameborder', 0)
            .attr('src', vMatch[0] + '/embed/simple')
            .attr('width', '600').attr('height', '600')
            .attr('class', 'vine-embed');
      } else if (vimMatch && vimMatch[3].length) {
        $video = $('<iframe webkitallowfullscreen mozallowfullscreen allowfullscreen>')
            .attr('frameborder', 0)
            .attr('src', '//player.vimeo.com/video/' + vimMatch[3])
            .attr('width', '640').attr('height', '360');
      } else if (dmMatch && dmMatch[2].length) {
        $video = $('<iframe>')
            .attr('frameborder', 0)
            .attr('src', '//www.dailymotion.com/embed/video/' + dmMatch[2])
            .attr('width', '640').attr('height', '360');
      } else if (youkuMatch && youkuMatch[1].length) {
        $video = $('<iframe webkitallowfullscreen mozallowfullscreen allowfullscreen>')
            .attr('frameborder', 0)
            .attr('height', '498')
            .attr('width', '510')
            .attr('src', '//player.youku.com/embed/' + youkuMatch[1]);
      } else if (mp4Match || oggMatch || webmMatch) {
        $video = $('<video controls>')
            .attr('src', url)
            .attr('width', '640').attr('height', '360');
      } else {
        // this is not a known video link. Now what, Cat? Now what?
        return false;
      }

      $video.addClass('note-video-clip');

      return $video[0];
    };


    this.show = function () {
      var text = context.invoke('editor.getSelectedText');
      context.invoke('editor.saveRange');
      this.showVideoDialog(text).then(function (url) {
        // [workaround] hide dialog before restore range for IE range focus
        ui.hideDialog(self.$dialog);
        context.invoke('editor.restoreRange');

        // build node
        var $node = self.createVideoNode(url);

        if ($node) {
          // insert video node
          context.invoke('editor.insertNode', $node);
        }
      }).fail(function () {
        context.invoke('editor.restoreRange');
      });
    };

    /**
     * show image dialog
     *
     * @param {jQuery} $dialog
     * @return {Promise}
     */
    this.showVideoDialog = function (text) {
      return $.Deferred(function (deferred) {
        var $videoUrl = self.$dialog.find('.note-video-url'),
            $videoBtn = self.$dialog.find('.note-video-btn');

        ui.onDialogShown(self.$dialog, function () {
          context.triggerEvent('dialog.shown');

          $videoUrl.val(text).on('input', function () {
            ui.toggleBtn($videoBtn, $videoUrl.val());
          }).trigger('focus');

          $videoBtn.click(function (event) {
            event.preventDefault();

            deferred.resolve($videoUrl.val());
          });

          self.bindEnterKey($videoUrl, $videoBtn);
        });

        ui.onDialogHidden(self.$dialog, function () {
          $videoUrl.off('input');
          $videoBtn.off('click');

          if (deferred.state() === 'pending') {
            deferred.reject();
          }
        });

        ui.showDialog(self.$dialog);
      });
    };
  };

  var HelpDialog = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var $editor = context.layoutInfo.editor;
    var options = context.options;
    var lang = options.langInfo;

    this.createShortCutList = function () {
      var keyMap = options.keyMap[agent.isMac ? 'mac' : 'pc'];
      return Object.keys(keyMap).map(function (key) {
        var command = keyMap[key];
        var $row = $('<div><div class="help-list-item"/></div>');
        $row.append($('<label><kbd>' + key + '</kdb></label>').css({
          'width': 180,
          'margin-right': 10
        })).append($('<span/>').html(context.memo('help.' + command) || command));
        return $row.html();
      }).join('');
    };

    this.initialize = function () {
      var $container = options.dialogsInBody ? $(document.body) : $editor;

      var body = [
        '<p class="text-center">',
        '<a href="//summernote.org/" target="_blank">Summernote 0.7.3</a> · ',
        '<a href="//github.com/summernote/summernote" target="_blank">Project</a> · ',
        '<a href="//github.com/summernote/summernote/issues" target="_blank">Issues</a>',
        '</p>'
      ].join('');

      this.$dialog = ui.dialog({
        title: lang.options.help,
        fade: options.dialogsFade,
        body: this.createShortCutList(),
        footer: body,
        callback: function ($node) {
          $node.find('.modal-body').css({
            'max-height': 300,
            'overflow': 'scroll'
          });
        }
      }).render().appendTo($container);
    };

    this.destroy = function () {
      ui.hideDialog(this.$dialog);
      this.$dialog.remove();
    };

    /**
     * show help dialog
     *
     * @return {Promise}
     */
    this.showHelpDialog = function () {
      return $.Deferred(function (deferred) {
        ui.onDialogShown(self.$dialog, function () {
          context.triggerEvent('dialog.shown');
          deferred.resolve();
        });
        ui.showDialog(self.$dialog);
      }).promise();
    };

    this.show = function () {
      context.invoke('editor.saveRange');
      this.showHelpDialog().then(function () {
        context.invoke('editor.restoreRange');
      });
    };
  };

  var AirPopover = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var options = context.options;

    var AIR_MODE_POPOVER_X_OFFSET = 20;

    this.events = {
      'summernote.keyup summernote.mouseup summernote.scroll': function () {
        self.update();
      },
      'summernote.change summernote.dialog.shown': function () {
        self.hide();
      },
      'summernote.focusout': function (we, e) {
        // [workaround] Firefox doesn't support relatedTarget on focusout
        //  - Ignore hide action on focus out in FF.
        if (agent.isFF) {
          return;
        }

        if (!e.relatedTarget || !dom.ancestor(e.relatedTarget, func.eq(self.$popover[0]))) {
          self.hide();
        }
      }
    };

    this.shouldInitialize = function () {
      return options.airMode && !list.isEmpty(options.popover.air);
    };

    this.initialize = function () {
      this.$popover = ui.popover({
        className: 'note-air-popover'
      }).render().appendTo('body');
      var $content = this.$popover.find('.popover-content');

      context.invoke('buttons.build', $content, options.popover.air);
    };

    this.destroy = function () {
      this.$popover.remove();
    };

    this.update = function () {
      var styleInfo = context.invoke('editor.currentStyle');
      if (styleInfo.range && !styleInfo.range.isCollapsed()) {
        var rect = list.last(styleInfo.range.getClientRects());
        if (rect) {
          var bnd = func.rect2bnd(rect);
          this.$popover.css({
            display: 'block',
            left: Math.max(bnd.left + bnd.width / 2, 0) - AIR_MODE_POPOVER_X_OFFSET,
            top: bnd.top + bnd.height
          });
        }
      } else {
        this.hide();
      }
    };

    this.hide = function () {
      this.$popover.hide();
    };
  };

  var HintPopover = function (context) {
    var self = this;
    var ui = $.summernote.ui;

    var POPOVER_DIST = 5;
    var hint = context.options.hint || [];
    var direction = context.options.hintDirection || 'bottom';
    var hints = $.isArray(hint) ? hint : [hint];

    this.events = {
      'summernote.keyup': function (we, e) {
        if (!e.isDefaultPrevented()) {
          self.handleKeyup(e);
        }
      },
      'summernote.keydown': function (we, e) {
        self.handleKeydown(e);
      },
      'summernote.dialog.shown': function () {
        self.hide();
      }
    };

    this.shouldInitialize = function () {
      return hints.length > 0;
    };

    this.initialize = function () {
      this.lastWordRange = null;
      this.$popover = ui.popover({
        className: 'note-hint-popover',
        hideArrow: true,
        direction: ''
      }).render().appendTo('body');

      this.$popover.hide();

      this.$content = this.$popover.find('.popover-content');

      this.$content.on('click', '.note-hint-item', function () {
        self.$content.find('.active').removeClass('active');
        $(this).addClass('active');
        self.replace();
      });
    };

    this.destroy = function () {
      this.$popover.remove();
    };

    this.selectItem = function ($item) {
      this.$content.find('.active').removeClass('active');
      $item.addClass('active');

      this.$content[0].scrollTop = $item[0].offsetTop - (this.$content.innerHeight() / 2);
    };

    this.moveDown = function () {
      var $current = this.$content.find('.note-hint-item.active');
      var $next = $current.next();

      if ($next.length) {
        this.selectItem($next);
      } else {
        var $nextGroup = $current.parent().next();

        if (!$nextGroup.length) {
          $nextGroup = this.$content.find('.note-hint-group').first();
        }

        this.selectItem($nextGroup.find('.note-hint-item').first());
      }
    };

    this.moveUp = function () {
      var $current = this.$content.find('.note-hint-item.active');
      var $prev = $current.prev();

      if ($prev.length) {
        this.selectItem($prev);
      } else {
        var $prevGroup = $current.parent().prev();

        if (!$prevGroup.length) {
          $prevGroup = this.$content.find('.note-hint-group').last();
        }

        this.selectItem($prevGroup.find('.note-hint-item').last());
      }
    };

    this.replace = function () {
      var $item = this.$content.find('.note-hint-item.active');

      if ($item.length) {
        var node = this.nodeFromItem($item);
        this.lastWordRange.insertNode(node);
        range.createFromNode(node).collapse().select();

        this.lastWordRange = null;
        this.hide();
        context.invoke('editor.focus');
      }

    };

    this.nodeFromItem = function ($item) {
      var hint = hints[$item.data('index')];
      var item = $item.data('item');
      var node = hint.content ? hint.content(item) : item;
      if (typeof node === 'string') {
        node = dom.createText(node);
      }
      return node;
    };

    this.createItemTemplates = function (hintIdx, items) {
      var hint = hints[hintIdx];
      return items.map(function (item, idx) {
        var $item = $('<div class="note-hint-item"/>');
        $item.append(hint.template ? hint.template(item) : item + '');
        $item.data({
          'index': hintIdx,
          'item': item
        });

        if (hintIdx === 0 && idx === 0) {
          $item.addClass('active');
        }
        return $item;
      });
    };

    this.handleKeydown = function (e) {
      if (!this.$popover.is(':visible')) {
        return;
      }

      if (e.keyCode === key.code.ENTER) {
        e.preventDefault();
        this.replace();
      } else if (e.keyCode === key.code.UP) {
        e.preventDefault();
        this.moveUp();
      } else if (e.keyCode === key.code.DOWN) {
        e.preventDefault();
        this.moveDown();
      }
    };

    this.searchKeyword = function (index, keyword, callback) {
      var hint = hints[index];
      if (hint && hint.match.test(keyword) && hint.search) {
        var matches = hint.match.exec(keyword);
        hint.search(matches[1], callback);
      } else {
        callback();
      }
    };

    this.createGroup = function (idx, keyword) {
      var $group = $('<div class="note-hint-group note-hint-group-' + idx + '"/>');
      this.searchKeyword(idx, keyword, function (items) {
        items = items || [];
        if (items.length) {
          $group.html(self.createItemTemplates(idx, items));
          self.show();
        }
      });

      return $group;
    };

    this.handleKeyup = function (e) {
      if (list.contains([key.code.ENTER, key.code.UP, key.code.DOWN], e.keyCode)) {
        if (e.keyCode === key.code.ENTER) {
          if (this.$popover.is(':visible')) {
            return;
          }
        }
      } else {
        var wordRange = context.invoke('editor.createRange').getWordRange();
        var keyword = wordRange.toString();
        if (hints.length && keyword) {
          this.$content.empty();

          var bnd = func.rect2bnd(list.last(wordRange.getClientRects()));
          if (bnd) {

            this.$popover.hide();

            this.lastWordRange = wordRange;

            hints.forEach(function (hint, idx) {
              if (hint.match.test(keyword)) {
                self.createGroup(idx, keyword).appendTo(self.$content);
              }
            });

            // set position for popover after group is created
            if (direction === 'top') {
              this.$popover.css({
                left: bnd.left,
                top: bnd.top - this.$popover.outerHeight() - POPOVER_DIST
              });
            } else {
              this.$popover.css({
                left: bnd.left,
                top: bnd.top + bnd.height + POPOVER_DIST
              });
            }

          }
        } else {
          this.hide();
        }
      }
    };

    this.show = function () {
      this.$popover.show();
    };

    this.hide = function () {
      this.$popover.hide();
    };
  };


  $.summernote = $.extend($.summernote, {
    version: '0.7.3',
    ui: ui,

    plugins: {},

    options: {
      modules: {
        'editor': Editor,
        'clipboard': Clipboard,
        'dropzone': Dropzone,
        'codeview': Codeview,
        'statusbar': Statusbar,
        'fullscreen': Fullscreen,
        'handle': Handle,
        // FIXME: HintPopover must be front of autolink
        //  - Script error about range when Enter key is pressed on hint popover
        'hintPopover': HintPopover,
        'autoLink': AutoLink,
        'autoSync': AutoSync,
        'placeholder': Placeholder,
        'buttons': Buttons,
        'toolbar': Toolbar,
        'linkDialog': LinkDialog,
        'linkPopover': LinkPopover,
        'imageDialog': ImageDialog,
        'imagePopover': ImagePopover,
        'videoDialog': VideoDialog,
        'helpDialog': HelpDialog,
        'airPopover': AirPopover
      },

      buttons: {},

      lang: 'en-US',

      // toolbar
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video']],
        ['view', ['fullscreen', 'codeview', 'help']]
      ],

      // popover
      popover: {
        image: [
          ['imagesize', ['imageSize100', 'imageSize50', 'imageSize25']],
          ['float', ['floatLeft', 'floatRight', 'floatNone']],
          ['remove', ['removeMedia']]
        ],
        link: [
          ['link', ['linkDialogShow', 'unlink']]
        ],
        air: [
          ['color', ['color']],
          ['font', ['bold', 'underline', 'clear']],
          ['para', ['ul', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture']]
        ]
      },

      // air mode: inline editor
      airMode: false,

      width: null,
      height: null,

      focus: false,
      tabSize: 4,
      styleWithSpan: true,
      shortcuts: true,
      textareaAutoSync: true,
      direction: null,

      styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'],

      fontNames: [
        'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New',
        'Helvetica Neue', 'Helvetica', 'Impact', 'Lucida Grande',
        'Tahoma', 'Times New Roman', 'Verdana'
      ],

      fontSizes: ['8', '9', '10', '11', '12', '14', '18', '24', '36'],

      // pallete colors(n x n)
      colors: [
        ['#000000', '#424242', '#636363', '#9C9C94', '#CEC6CE', '#EFEFEF', '#F7F7F7', '#FFFFFF'],
        ['#FF0000', '#FF9C00', '#FFFF00', '#00FF00', '#00FFFF', '#0000FF', '#9C00FF', '#FF00FF'],
        ['#F7C6CE', '#FFE7CE', '#FFEFC6', '#D6EFD6', '#CEDEE7', '#CEE7F7', '#D6D6E7', '#E7D6DE'],
        ['#E79C9C', '#FFC69C', '#FFE79C', '#B5D6A5', '#A5C6CE', '#9CC6EF', '#B5A5D6', '#D6A5BD'],
        ['#E76363', '#F7AD6B', '#FFD663', '#94BD7B', '#73A5AD', '#6BADDE', '#8C7BC6', '#C67BA5'],
        ['#CE0000', '#E79439', '#EFC631', '#6BA54A', '#4A7B8C', '#3984C6', '#634AA5', '#A54A7B'],
        ['#9C0000', '#B56308', '#BD9400', '#397B21', '#104A5A', '#085294', '#311873', '#731842'],
        ['#630000', '#7B3900', '#846300', '#295218', '#083139', '#003163', '#21104A', '#4A1031']
      ],

      lineHeights: ['1.0', '1.2', '1.4', '1.5', '1.6', '1.8', '2.0', '3.0'],

      tableClassName: 'table table-bordered',

      insertTableMaxSize: {
        col: 10,
        row: 10
      },

      dialogsInBody: false,
      dialogsFade: false,

      maximumImageFileSize: null,

      callbacks: {
        onInit: null,
        onFocus: null,
        onBlur: null,
        onEnter: null,
        onKeyup: null,
        onKeydown: null,
        onSubmit: null,
        onImageUpload: null,
        onImageUploadError: null
      },

      codemirror: {
        mode: 'text/html',
        htmlMode: true,
        lineNumbers: true
      },

      keyMap: {
        pc: {
          'ENTER': 'insertParagraph',
          'CTRL+Z': 'undo',
          'CTRL+Y': 'redo',
          'TAB': 'tab',
          'SHIFT+TAB': 'untab',
          'CTRL+B': 'bold',
          'CTRL+I': 'italic',
          'CTRL+U': 'underline',
          'CTRL+SHIFT+S': 'strikethrough',
          'CTRL+BACKSLASH': 'removeFormat',
          'CTRL+SHIFT+L': 'justifyLeft',
          'CTRL+SHIFT+E': 'justifyCenter',
          'CTRL+SHIFT+R': 'justifyRight',
          'CTRL+SHIFT+J': 'justifyFull',
          'CTRL+SHIFT+NUM7': 'insertUnorderedList',
          'CTRL+SHIFT+NUM8': 'insertOrderedList',
          'CTRL+LEFTBRACKET': 'outdent',
          'CTRL+RIGHTBRACKET': 'indent',
          'CTRL+NUM0': 'formatPara',
          'CTRL+NUM1': 'formatH1',
          'CTRL+NUM2': 'formatH2',
          'CTRL+NUM3': 'formatH3',
          'CTRL+NUM4': 'formatH4',
          'CTRL+NUM5': 'formatH5',
          'CTRL+NUM6': 'formatH6',
          'CTRL+ENTER': 'insertHorizontalRule',
          'CTRL+K': 'linkDialog.show'
        },

        mac: {
          'ENTER': 'insertParagraph',
          'CMD+Z': 'undo',
          'CMD+SHIFT+Z': 'redo',
          'TAB': 'tab',
          'SHIFT+TAB': 'untab',
          'CMD+B': 'bold',
          'CMD+I': 'italic',
          'CMD+U': 'underline',
          'CMD+SHIFT+S': 'strikethrough',
          'CMD+BACKSLASH': 'removeFormat',
          'CMD+SHIFT+L': 'justifyLeft',
          'CMD+SHIFT+E': 'justifyCenter',
          'CMD+SHIFT+R': 'justifyRight',
          'CMD+SHIFT+J': 'justifyFull',
          'CMD+SHIFT+NUM7': 'insertUnorderedList',
          'CMD+SHIFT+NUM8': 'insertOrderedList',
          'CMD+LEFTBRACKET': 'outdent',
          'CMD+RIGHTBRACKET': 'indent',
          'CMD+NUM0': 'formatPara',
          'CMD+NUM1': 'formatH1',
          'CMD+NUM2': 'formatH2',
          'CMD+NUM3': 'formatH3',
          'CMD+NUM4': 'formatH4',
          'CMD+NUM5': 'formatH5',
          'CMD+NUM6': 'formatH6',
          'CMD+ENTER': 'insertHorizontalRule',
          'CMD+K': 'linkDialog.show'
        }
      },
      icons: {
        'align': 'fa fa-align-left',
        'alignCenter': 'fa fa-align-center',
        'alignJustify': 'fa fa-align-justify',
        'alignLeft': 'fa fa-align-left',
        'alignRight': 'fa fa-align-right',
        'indent': 'fa fa-indent',
        'outdent': 'fa fa-outdent',
        'arrowsAlt': 'fa fa-arrows-alt',
        'bold': 'fa fa-bold',
        'caret': 'caret',
        'circle': 'fa fa-circle',
        'close': 'fa fa-close',
        'code': 'fa fa-code',
        'eraser': 'fa fa-eraser',
        'font': 'fa fa-font',
        'frame': 'fa fa-frame',
        'italic': 'fa fa-italic',
        'link': 'fa fa-link',
        'unlink': 'fa fa-chain-broken',
        'magic': 'fa fa-magic',
        'menuCheck': 'fa fa-check',
        'minus': 'fa fa-minus',
        'orderedlist': 'fa fa-list-ol',
        'pencil': 'fa fa-pencil',
        'picture': 'fa fa-picture-o',
        'question': 'fa fa-question',
        'redo': 'fa fa-repeat',
        'square': 'fa fa-square',
        'strikethrough': 'fa fa-strikethrough',
        'subscript': 'fa fa-subscript',
        'superscript': 'fa fa-superscript',
        'table': 'fa fa-table',
        'textHeight': 'fa fa-text-height',
        'trash': 'fa fa-trash',
        'underline': 'fa fa-underline',
        'undo': 'fa fa-undo',
        'unorderedlist': 'fa fa-list-ul',
        'video': 'fa fa-youtube-play'
      }
    }
  });

}));



(jQuery, window, document);
! function(n) {
    "use strict";
    window.nifty = {
        container: n("#container"),
        contentContainer: n("#content-container"),
        navbar: n("#navbar"),
        mainNav: n("#mainnav-container"),
        aside: n("#aside-container"),
        footer: n("#footer"),
        scrollTop: n("#scroll-top"),
        window: n(window),
        body: n("body"),
        bodyHtml: n("body, html"),
        document: n(document),
        screenSize: "",
        isMobile: function() {
            return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
        }(),
        randomInt: function(n, t) {
            return Math.floor(Math.random() * (t - n + 1) + n)
        },
        transition: function() {
            var n = document.body || document.documentElement,
                t = n.style,
                i = void 0 !== t.transition || void 0 !== t.WebkitTransition;
            return i
        }()
    }, nifty.window.on("load", function() {
        var t = n(".add-tooltip");
        t.length && t.tooltip();
        var i = n(".add-popover");
        i.length && i.popover();
        var e = n(".nano");
        e.length && e.nanoScroller({
            preventPageScrolling: !0
        }), n("#navbar-container .navbar-top-links").on("shown.bs.dropdown", ".dropdown", function() {
            n(this).find(".nano").nanoScroller({
                preventPageScrolling: !0
            })
        }), nifty.body.addClass("nifty-ready")
    })
}





(window.jQuery); /*! Bootstrap-select v1.6.2 (http://silviomoreto.github.io/bootstrap-select/) ** Copyright 2013-2014 bootstrap-select * Licensed under MIT (https://github.com/silviomoreto/bootstrap-select/blob/master/LICENSE) */
! function(a) {
    "use strict";

    function b(a, b) {
        return a.toUpperCase().indexOf(b.toUpperCase()) > -1
    }

    function c(b) {
        var c = [{
            re: /[\xC0-\xC6]/g,
            ch: "A"
        }, {
            re: /[\xE0-\xE6]/g,
            ch: "a"
        }, {
            re: /[\xC8-\xCB]/g,
            ch: "E"
        }, {
            re: /[\xE8-\xEB]/g,
            ch: "e"
        }, {
            re: /[\xCC-\xCF]/g,
            ch: "I"
        }, {
            re: /[\xEC-\xEF]/g,
            ch: "i"
        }, {
            re: /[\xD2-\xD6]/g,
            ch: "O"
        }, {
            re: /[\xF2-\xF6]/g,
            ch: "o"
        }, {
            re: /[\xD9-\xDC]/g,
            ch: "U"
        }, {
            re: /[\xF9-\xFC]/g,
            ch: "u"
        }, {
            re: /[\xC7-\xE7]/g,
            ch: "c"
        }, {
            re: /[\xD1]/g,
            ch: "N"
        }, {
            re: /[\xF1]/g,
            ch: "n"
        }];
        return a.each(c, function() {
            b = b.replace(this.re, this.ch)
        }), b
    }

    function d(b, c) {
        var d = arguments,
            f = b,
            b = d[0],
            c = d[1];
        [].shift.apply(d), "undefined" == typeof b && (b = f);
        var g, h = this.each(function() {
            var f = a(this);
            if (f.is("select")) {
                var h = f.data("selectpicker"),
                    i = "object" == typeof b && b;
                if (h) {
                    if (i)
                        for (var j in i) i.hasOwnProperty(j) && (h.options[j] = i[j])
                } else {
                    var k = a.extend({}, e.DEFAULTS, a.fn.selectpicker.defaults || {}, f.data(), i);
                    f.data("selectpicker", h = new e(this, k, c))
                }
                "string" == typeof b && (g = h[b] instanceof Function ? h[b].apply(h, d) : h.options[b])
            }
        });
        return "undefined" != typeof g ? g : h
    }
    a.expr[":"].icontains = function(c, d, e) {
        return b(a(c).text(), e[3])
    }, a.expr[":"].aicontains = function(c, d, e) {
        return b(a(c).data("normalizedText") || a(c).text(), e[3])
    };
    var e = function(b, c, d) {
        d && (d.stopPropagation(), d.preventDefault()), this.$element = a(b), this.$newElement = null, this.$button = null, this.$menu = null, this.$lis = null, this.options = c, null === this.options.title && (this.options.title = this.$element.attr("title")), this.val = e.prototype.val, this.render = e.prototype.render, this.refresh = e.prototype.refresh, this.setStyle = e.prototype.setStyle, this.selectAll = e.prototype.selectAll, this.deselectAll = e.prototype.deselectAll, this.destroy = e.prototype.remove, this.remove = e.prototype.remove, this.show = e.prototype.show, this.hide = e.prototype.hide, this.init()
    };
    e.VERSION = "1.6.2", e.DEFAULTS = {
        noneSelectedText: "Nothing selected",
        noneResultsText: "No results match",
        countSelectedText: function(a) {
            return 1 == a ? "{0} item selected" : "{0} items selected"
        },
        maxOptionsText: function(a, b) {
            var c = [];
            return c[0] = 1 == a ? "Limit reached ({n} item max)" : "Limit reached ({n} items max)", c[1] = 1 == b ? "Group limit reached ({n} item max)" : "Group limit reached ({n} items max)", c
        },
        selectAllText: "Select All",
        deselectAllText: "Deselect All",
        multipleSeparator: ", ",
        style: "btn-default",
        size: "auto",
        title: null,
        selectedTextFormat: "values",
        width: !1,
        container: !1,
        hideDisabled: !1,
        showSubtext: !1,
        showIcon: !0,
        showContent: !0,
        dropupAuto: !0,
        header: !1,
        liveSearch: !1,
        actionsBox: !1,
        iconBase: "fa",
        tickIcon: "fa-check",
        maxOptions: !1,
        mobile: !1,
        selectOnTab: !1,
        dropdownAlignRight: !1,
        searchAccentInsensitive: !1
    }, e.prototype = {
        constructor: e,
        init: function() {
            var b = this,
                c = this.$element.attr("id");
            this.$element.hide(), this.multiple = this.$element.prop("multiple"), this.autofocus = this.$element.prop("autofocus"), this.$newElement = this.createView(), this.$element.after(this.$newElement), this.$menu = this.$newElement.find("> .dropdown-menu"), this.$button = this.$newElement.find("> button"), this.$searchbox = this.$newElement.find("input"), this.options.dropdownAlignRight && this.$menu.addClass("dropdown-menu-right"), "undefined" != typeof c && (this.$button.attr("data-id", c), a('label[for="' + c + '"]').click(function(a) {
                a.preventDefault(), b.$button.focus()
            })), this.checkDisabled(), this.clickListener(), this.options.liveSearch && this.liveSearchListener(), this.render(), this.liHeight(), this.setStyle(), this.setWidth(), this.options.container && this.selectPosition(), this.$menu.data("this", this), this.$newElement.data("this", this), this.options.mobile && this.mobile()
        },
        createDropdown: function() {
            var b = this.multiple ? " show-tick" : "",
                c = this.$element.parent().hasClass("input-group") ? " input-group-btn" : "",
                d = this.autofocus ? " autofocus" : "",
                e = this.$element.parents().hasClass("form-group-lg") ? " btn-lg" : this.$element.parents().hasClass("form-group-sm") ? " btn-sm" : "",
                f = this.options.header ? '<div class="popover-title"><button type="button" class="close" aria-hidden="true">&times;</button>' + this.options.header + "</div>" : "",
                g = this.options.liveSearch ? '<div class="bs-searchbox"><input type="text" class="input-block-level form-control" autocomplete="off" /></div>' : "",
                h = this.options.actionsBox ? '<div class="bs-actionsbox"><div class="btn-group btn-block"><button class="actions-btn bs-select-all btn btn-sm btn-default">' + this.options.selectAllText + '</button><button class="actions-btn bs-deselect-all btn btn-sm btn-default">' + this.options.deselectAllText + "</button></div></div>" : "",
                i = '<div class="btn-group bootstrap-select' + b + c + '"><button type="button" class="btn dropdown-toggle selectpicker' + e + '" data-toggle="dropdown"' + d + '><span class="filter-option pull-left"></span>&nbsp;<span class="caret"></span></button><div class="dropdown-menu open">' + f + g + h + '<ul class="dropdown-menu inner selectpicker" role="menu"></ul></div></div>';
            return a(i)
        },
        createView: function() {
            var a = this.createDropdown(),
                b = this.createLi();
            return a.find("ul").append(b), a
        },
        reloadLi: function() {
            this.destroyLi();
            var a = this.createLi();
            this.$menu.find("ul").append(a)
        },
        destroyLi: function() {
            this.$menu.find("li").remove()
        },
        createLi: function() {
            var b = this,
                d = [],
                e = 0,
                f = function(a, b, c) {
                    return "<li" + ("undefined" != typeof c ? ' class="' + c + '"' : "") + ("undefined" != typeof b | null === b ? ' data-original-index="' + b + '"' : "") + ">" + a + "</li>"
                },
                g = function(d, e, f, g) {
                    var h = c(a.trim(a("<div/>").html(d).text()).replace(/\s\s+/g, " "));
                    return '<a tabindex="0"' + ("undefined" != typeof e ? ' class="' + e + '"' : "") + ("undefined" != typeof f ? ' style="' + f + '"' : "") + ("undefined" != typeof g ? 'data-optgroup="' + g + '"' : "") + ' data-normalized-text="' + h + '">' + d + '<span class="' + b.options.iconBase + " " + b.options.tickIcon + ' check-mark"></span></a>'
                };
            return this.$element.find("option").each(function() {
                var c = a(this),
                    h = c.attr("class") || "",
                    i = c.attr("style"),
                    j = c.data("content") ? c.data("content") : c.html(),
                    k = "undefined" != typeof c.data("subtext") ? '<small class="muted text-muted">' + c.data("subtext") + "</small>" : "",
                    l = "undefined" != typeof c.data("icon") ? '<span class="' + b.options.iconBase + " " + c.data("icon") + '"></span> ' : "",
                    m = c.is(":disabled") || c.parent().is(":disabled"),
                    n = c[0].index;
                if ("" !== l && m && (l = "<span>" + l + "</span>"), c.data("content") || (j = l + '<span class="text">' + j + k + "</span>"), !b.options.hideDisabled || !m)
                    if (c.parent().is("optgroup") && c.data("divider") !== !0) {
                        if (0 === c.index()) {
                            e += 1;
                            var o = c.parent().attr("label"),
                                p = "undefined" != typeof c.parent().data("subtext") ? '<small class="muted text-muted">' + c.parent().data("subtext") + "</small>" : "",
                                q = c.parent().data("icon") ? '<span class="' + b.options.iconBase + " " + c.parent().data("icon") + '"></span> ' : "";
                            o = q + '<span class="text">' + o + p + "</span>", 0 !== n && d.length > 0 && d.push(f("", null, "divider")), d.push(f(o, null, "dropdown-header"))
                        }
                        d.push(f(g(j, "opt " + h, i, e), n))
                    } else d.push(c.data("divider") === !0 ? f("", n, "divider") : c.data("hidden") === !0 ? f(g(j, h, i), n, "hide is-hidden") : f(g(j, h, i), n))
            }), this.multiple || 0 !== this.$element.find("option:selected").length || this.options.title || this.$element.find("option").eq(0).prop("selected", !0).attr("selected", "selected"), a(d.join(""))
        },
        findLis: function() {
            return null == this.$lis && (this.$lis = this.$menu.find("li")), this.$lis
        },
        render: function(b) {
            var c = this;
            b !== !1 && this.$element.find("option").each(function(b) {
                c.setDisabled(b, a(this).is(":disabled") || a(this).parent().is(":disabled")), c.setSelected(b, a(this).is(":selected"))
            }), this.tabIndex();
            var d = this.options.hideDisabled ? ":not([disabled])" : "",
                e = this.$element.find("option:selected" + d).map(function() {
                    var b, d = a(this),
                        e = d.data("icon") && c.options.showIcon ? '<i class="' + c.options.iconBase + " " + d.data("icon") + '"></i> ' : "";
                    return b = c.options.showSubtext && d.attr("data-subtext") && !c.multiple ? ' <small class="muted text-muted">' + d.data("subtext") + "</small>" : "", d.data("content") && c.options.showContent ? d.data("content") : "undefined" != typeof d.attr("title") ? d.attr("title") : e + d.html() + b
                }).toArray(),
                f = this.multiple ? e.join(this.options.multipleSeparator) : e[0];
            if (this.multiple && this.options.selectedTextFormat.indexOf("count") > -1) {
                var g = this.options.selectedTextFormat.split(">");
                if (g.length > 1 && e.length > g[1] || 1 == g.length && e.length >= 2) {
                    d = this.options.hideDisabled ? ", [disabled]" : "";
                    var h = this.$element.find("option").not('[data-divider="true"], [data-hidden="true"]' + d).length,
                        i = "function" == typeof this.options.countSelectedText ? this.options.countSelectedText(e.length, h) : this.options.countSelectedText;
                    f = i.replace("{0}", e.length.toString()).replace("{1}", h.toString())
                }
            }
            this.options.title = this.$element.attr("title"), "static" == this.options.selectedTextFormat && (f = this.options.title), f || (f = "undefined" != typeof this.options.title ? this.options.title : this.options.noneSelectedText), this.$button.attr("title", a.trim(a("<div/>").html(f).text()).replace(/\s\s+/g, " ")), this.$newElement.find(".filter-option").html(f)
        },
        setStyle: function(a, b) {
            this.$element.attr("class") && this.$newElement.addClass(this.$element.attr("class").replace(/selectpicker|mobile-device|validate\[.*\]/gi, ""));
            var c = a ? a : this.options.style;
            "add" == b ? this.$button.addClass(c) : "remove" == b ? this.$button.removeClass(c) : (this.$button.removeClass(this.options.style), this.$button.addClass(c))
        },
        liHeight: function() {
            if (this.options.size !== !1) {
                var a = this.$menu.parent().clone().find("> .dropdown-toggle").prop("autofocus", !1).end().appendTo("body"),
                    b = a.addClass("open").find("> .dropdown-menu"),
                    c = b.find("li").not(".divider").not(".dropdown-header").filter(":visible").children("a").outerHeight(),
                    d = this.options.header ? b.find(".popover-title").outerHeight() : 0,
                    e = this.options.liveSearch ? b.find(".bs-searchbox").outerHeight() : 0,
                    f = this.options.actionsBox ? b.find(".bs-actionsbox").outerHeight() : 0;
                a.remove(), this.$newElement.data("liHeight", c).data("headerHeight", d).data("searchHeight", e).data("actionsHeight", f)
            }
        },
        setSize: function() {
            this.findLis();
            var b, c, d, e = this,
                f = this.$menu,
                g = f.find(".inner"),
                h = this.$newElement.outerHeight(),
                i = this.$newElement.data("liHeight"),
                j = this.$newElement.data("headerHeight"),
                k = this.$newElement.data("searchHeight"),
                l = this.$newElement.data("actionsHeight"),
                m = this.$lis.filter(".divider").outerHeight(!0),
                n = parseInt(f.css("padding-top")) + parseInt(f.css("padding-bottom")) + parseInt(f.css("border-top-width")) + parseInt(f.css("border-bottom-width")),
                o = this.options.hideDisabled ? ", .disabled" : "",
                p = a(window),
                q = n + parseInt(f.css("margin-top")) + parseInt(f.css("margin-bottom")) + 2,
                r = function() {
                    c = e.$newElement.offset().top - p.scrollTop(), d = p.height() - c - h
                };
            if (r(), this.options.header && f.css("padding-top", 0), "auto" == this.options.size) {
                var s = function() {
                    var a, h = e.$lis.not(".hide");
                    r(), b = d - q, e.options.dropupAuto && e.$newElement.toggleClass("dropup", c > d && b - q < f.height()), e.$newElement.hasClass("dropup") && (b = c - q), a = h.length + h.filter(".dropdown-header").length > 3 ? 3 * i + q - 2 : 0, f.css({
                        "max-height": b + "px",
                        overflow: "hidden",
                        "min-height": a + j + k + l + "px"
                    }), g.css({
                        "max-height": b - j - k - l - n + "px",
                        "overflow-y": "auto",
                        "min-height": Math.max(a - n, 0) + "px"
                    })
                };
                s(), this.$searchbox.off("input.getSize propertychange.getSize").on("input.getSize propertychange.getSize", s), a(window).off("resize.getSize").on("resize.getSize", s), a(window).off("scroll.getSize").on("scroll.getSize", s)
            } else if (this.options.size && "auto" != this.options.size && f.find("li" + o).length > this.options.size) {
                var t = this.$lis.not(".divider" + o).find(" > *").slice(0, this.options.size).last().parent().index(),
                    u = this.$lis.slice(0, t + 1).filter(".divider").length;
                b = i * this.options.size + u * m + n, e.options.dropupAuto && this.$newElement.toggleClass("dropup", c > d && b < f.height()), f.css({
                    "max-height": b + j + k + l + "px",
                    overflow: "hidden"
                }), g.css({
                    "max-height": b - n + "px",
                    "overflow-y": "auto"
                })
            }
        },
        setWidth: function() {
            if ("auto" == this.options.width) {
                this.$menu.css("min-width", "0");
                var a = this.$newElement.clone().appendTo("body"),
                    b = a.find("> .dropdown-menu").css("width"),
                    c = a.css("width", "auto").find("> button").css("width");
                a.remove(), this.$newElement.css("width", Math.max(parseInt(b), parseInt(c)) + "px")
            } else "fit" == this.options.width ? (this.$menu.css("min-width", ""), this.$newElement.css("width", "").addClass("fit-width")) : this.options.width ? (this.$menu.css("min-width", ""), this.$newElement.css("width", this.options.width)) : (this.$menu.css("min-width", ""), this.$newElement.css("width", ""));
            this.$newElement.hasClass("fit-width") && "fit" !== this.options.width && this.$newElement.removeClass("fit-width")
        },
        selectPosition: function() {
            var b, c, d = this,
                e = "<div />",
                f = a(e),
                g = function(a) {
                    f.addClass(a.attr("class").replace(/form-control/gi, "")).toggleClass("dropup", a.hasClass("dropup")), b = a.offset(), c = a.hasClass("dropup") ? 0 : a[0].offsetHeight, f.css({
                        top: b.top + c,
                        left: b.left,
                        width: a[0].offsetWidth,
                        position: "absolute"
                    })
                };
            this.$newElement.on("click", function() {
                d.isDisabled() || (g(a(this)), f.appendTo(d.options.container), f.toggleClass("open", !a(this).hasClass("open")), f.append(d.$menu))
            }), a(window).resize(function() {
                g(d.$newElement)
            }), a(window).on("scroll", function() {
                g(d.$newElement)
            }), a("html").on("click", function(b) {
                a(b.target).closest(d.$newElement).length < 1 && f.removeClass("open")
            })
        },
        setSelected: function(a, b) {
            this.findLis(), this.$lis.filter('[data-original-index="' + a + '"]').toggleClass("selected", b)
        },
        setDisabled: function(a, b) {
            this.findLis(), b ? this.$lis.filter('[data-original-index="' + a + '"]').addClass("disabled").find("a").attr("href", "#").attr("tabindex", -1) : this.$lis.filter('[data-original-index="' + a + '"]').removeClass("disabled").find("a").removeAttr("href").attr("tabindex", 0)
        },
        isDisabled: function() {
            return this.$element.is(":disabled")
        },
        checkDisabled: function() {
            var a = this;
            this.isDisabled() ? this.$button.addClass("disabled").attr("tabindex", -1) : (this.$button.hasClass("disabled") && this.$button.removeClass("disabled"), -1 == this.$button.attr("tabindex") && (this.$element.data("tabindex") || this.$button.removeAttr("tabindex"))), this.$button.click(function() {
                return !a.isDisabled()
            })
        },
        tabIndex: function() {
            this.$element.is("[tabindex]") && (this.$element.data("tabindex", this.$element.attr("tabindex")), this.$button.attr("tabindex", this.$element.data("tabindex")))
        },
        clickListener: function() {
            var b = this;
            this.$newElement.on("touchstart.dropdown", ".dropdown-menu", function(a) {
                a.stopPropagation()
            }), this.$newElement.on("click", function() {
                b.setSize(), b.options.liveSearch || b.multiple || setTimeout(function() {
                    b.$menu.find(".selected a").focus()
                }, 10)
            }), this.$menu.on("click", "li a", function(c) {
                var d = a(this),
                    e = d.parent().data("originalIndex"),
                    f = b.$element.val(),
                    g = b.$element.prop("selectedIndex");
                if (b.multiple && c.stopPropagation(), c.preventDefault(), !b.isDisabled() && !d.parent().hasClass("disabled")) {
                    var h = b.$element.find("option"),
                        i = h.eq(e),
                        j = i.prop("selected"),
                        k = i.parent("optgroup"),
                        l = b.options.maxOptions,
                        m = k.data("maxOptions") || !1;
                    if (b.multiple) {
                        if (i.prop("selected", !j), b.setSelected(e, !j), d.blur(), l !== !1 || m !== !1) {
                            var n = l < h.filter(":selected").length,
                                o = m < k.find("option:selected").length;
                            if (l && n || m && o)
                                if (l && 1 == l) h.prop("selected", !1), i.prop("selected", !0), b.$menu.find(".selected").removeClass("selected"), b.setSelected(e, !0);
                                else if (m && 1 == m) {
                                k.find("option:selected").prop("selected", !1), i.prop("selected", !0);
                                var p = d.data("optgroup");
                                b.$menu.find(".selected").has('a[data-optgroup="' + p + '"]').removeClass("selected"), b.setSelected(e, !0)
                            } else {
                                var q = "function" == typeof b.options.maxOptionsText ? b.options.maxOptionsText(l, m) : b.options.maxOptionsText,
                                    r = q[0].replace("{n}", l),
                                    s = q[1].replace("{n}", m),
                                    t = a('<div class="notify"></div>');
                                q[2] && (r = r.replace("{var}", q[2][l > 1 ? 0 : 1]), s = s.replace("{var}", q[2][m > 1 ? 0 : 1])), i.prop("selected", !1), b.$menu.append(t), l && n && (t.append(a("<div>" + r + "</div>")), b.$element.trigger("maxReached.bs.select")), m && o && (t.append(a("<div>" + s + "</div>")), b.$element.trigger("maxReachedGrp.bs.select")), setTimeout(function() {
                                    b.setSelected(e, !1)
                                }, 10), t.delay(750).fadeOut(300, function() {
                                    a(this).remove()
                                })
                            }
                        }
                    } else h.prop("selected", !1), i.prop("selected", !0), b.$menu.find(".selected").removeClass("selected"), b.setSelected(e, !0);
                    b.multiple ? b.options.liveSearch && b.$searchbox.focus() : b.$button.focus(), (f != b.$element.val() && b.multiple || g != b.$element.prop("selectedIndex") && !b.multiple) && b.$element.change()
                }
            }), this.$menu.on("click", "li.disabled a, .popover-title, .popover-title :not(.close)", function(a) {
                a.target == this && (a.preventDefault(), a.stopPropagation(), b.options.liveSearch ? b.$searchbox.focus() : b.$button.focus())
            }), this.$menu.on("click", "li.divider, li.dropdown-header", function(a) {
                a.preventDefault(), a.stopPropagation(), b.options.liveSearch ? b.$searchbox.focus() : b.$button.focus()
            }), this.$menu.on("click", ".popover-title .close", function() {
                b.$button.focus()
            }), this.$searchbox.on("click", function(a) {
                a.stopPropagation()
            }), this.$menu.on("click", ".actions-btn", function(c) {
                b.options.liveSearch ? b.$searchbox.focus() : b.$button.focus(), c.preventDefault(), c.stopPropagation(), a(this).is(".bs-select-all") ? b.selectAll() : b.deselectAll(), b.$element.change()
            }), this.$element.change(function() {
                b.render(!1)
            })
        },
        liveSearchListener: function() {
            var b = this,
                d = a('<li class="no-results"></li>');
            this.$newElement.on("click.dropdown.data-api", function() {
                b.$menu.find(".active").removeClass("active"), b.$searchbox.val() && (b.$searchbox.val(""), b.$lis.not(".is-hidden").removeClass("hide"), d.parent().length && d.remove()), b.multiple || b.$menu.find(".selected").addClass("active"), setTimeout(function() {
                    b.$searchbox.focus()
                }, 10)
            }), this.$searchbox.on("input propertychange", function() {
                b.$searchbox.val() ? (b.options.searchAccentInsensitive ? b.$lis.not(".is-hidden").removeClass("hide").find("a").not(":aicontains(" + c(b.$searchbox.val()) + ")").parent().addClass("hide") : b.$lis.not(".is-hidden").removeClass("hide").find("a").not(":icontains(" + b.$searchbox.val() + ")").parent().addClass("hide"), b.$menu.find("li").filter(":visible:not(.no-results)").length ? d.parent().length && d.remove() : (d.parent().length && d.remove(), d.html(b.options.noneResultsText + ' "' + b.$searchbox.val() + '"').show(), b.$menu.find("li").last().after(d))) : (b.$lis.not(".is-hidden").removeClass("hide"), d.parent().length && d.remove()), b.$menu.find("li.active").removeClass("active"), b.$menu.find("li").filter(":visible:not(.divider)").eq(0).addClass("active").find("a").focus(), a(this).focus()
            })
        },
        val: function(a) {
            return "undefined" != typeof a ? (this.$element.val(a), this.render(), this.$element) : this.$element.val()
        },
        selectAll: function() {
            this.findLis(), this.$lis.not(".divider").not(".disabled").not(".selected").filter(":visible").find("a").click()
        },
        deselectAll: function() {
            this.findLis(), this.$lis.not(".divider").not(".disabled").filter(".selected").filter(":visible").find("a").click()
        },
        keydown: function(b) {
            var d, e, f, g, h, i, j, k, l, m = a(this),
                n = m.is("input") ? m.parent().parent() : m.parent(),
                o = n.data("this"),
                p = {
                    32: " ",
                    48: "0",
                    49: "1",
                    50: "2",
                    51: "3",
                    52: "4",
                    53: "5",
                    54: "6",
                    55: "7",
                    56: "8",
                    57: "9",
                    59: ";",
                    65: "a",
                    66: "b",
                    67: "c",
                    68: "d",
                    69: "e",
                    70: "f",
                    71: "g",
                    72: "h",
                    73: "i",
                    74: "j",
                    75: "k",
                    76: "l",
                    77: "m",
                    78: "n",
                    79: "o",
                    80: "p",
                    81: "q",
                    82: "r",
                    83: "s",
                    84: "t",
                    85: "u",
                    86: "v",
                    87: "w",
                    88: "x",
                    89: "y",
                    90: "z",
                    96: "0",
                    97: "1",
                    98: "2",
                    99: "3",
                    100: "4",
                    101: "5",
                    102: "6",
                    103: "7",
                    104: "8",
                    105: "9"
                };
            if (o.options.liveSearch && (n = m.parent().parent()), o.options.container && (n = o.$menu), d = a("[role=menu] li a", n), l = o.$menu.parent().hasClass("open"), !l && /([0-9]|[A-z])/.test(String.fromCharCode(b.keyCode)) && (o.options.container ? o.$newElement.trigger("click") : (o.setSize(), o.$menu.parent().addClass("open"), l = !0), o.$searchbox.focus()), o.options.liveSearch && (/(^9$|27)/.test(b.keyCode.toString(10)) && l && 0 === o.$menu.find(".active").length && (b.preventDefault(), o.$menu.parent().removeClass("open"), o.$button.focus()), d = a("[role=menu] li:not(.divider):not(.dropdown-header):visible", n), m.val() || /(38|40)/.test(b.keyCode.toString(10)) || 0 === d.filter(".active").length && (d = o.$newElement.find("li").filter(o.options.searchAccentInsensitive ? ":aicontains(" + c(p[b.keyCode]) + ")" : ":icontains(" + p[b.keyCode] + ")"))), d.length) {
                if (/(38|40)/.test(b.keyCode.toString(10))) e = d.index(d.filter(":focus")), g = d.parent(":not(.disabled):visible").first().index(), h = d.parent(":not(.disabled):visible").last().index(), f = d.eq(e).parent().nextAll(":not(.disabled):visible").eq(0).index(), i = d.eq(e).parent().prevAll(":not(.disabled):visible").eq(0).index(), j = d.eq(f).parent().prevAll(":not(.disabled):visible").eq(0).index(), o.options.liveSearch && (d.each(function(b) {
                    a(this).is(":not(.disabled)") && a(this).data("index", b)
                }), e = d.index(d.filter(".active")), g = d.filter(":not(.disabled):visible").first().data("index"), h = d.filter(":not(.disabled):visible").last().data("index"), f = d.eq(e).nextAll(":not(.disabled):visible").eq(0).data("index"), i = d.eq(e).prevAll(":not(.disabled):visible").eq(0).data("index"), j = d.eq(f).prevAll(":not(.disabled):visible").eq(0).data("index")), k = m.data("prevIndex"), 38 == b.keyCode && (o.options.liveSearch && (e -= 1), e != j && e > i && (e = i), g > e && (e = g), e == k && (e = h)), 40 == b.keyCode && (o.options.liveSearch && (e += 1), -1 == e && (e = 0), e != j && f > e && (e = f), e > h && (e = h), e == k && (e = g)), m.data("prevIndex", e), o.options.liveSearch ? (b.preventDefault(), m.is(".dropdown-toggle") || (d.removeClass("active"), d.eq(e).addClass("active").find("a").focus(), m.focus())) : d.eq(e).focus();
                else if (!m.is("input")) {
                    var q, r, s = [];
                    d.each(function() {
                        a(this).parent().is(":not(.disabled)") && a.trim(a(this).text().toLowerCase()).substring(0, 1) == p[b.keyCode] && s.push(a(this).parent().index())
                    }), q = a(document).data("keycount"), q++, a(document).data("keycount", q), r = a.trim(a(":focus").text().toLowerCase()).substring(0, 1), r != p[b.keyCode] ? (q = 1, a(document).data("keycount", q)) : q >= s.length && (a(document).data("keycount", 0), q > s.length && (q = 1)), d.eq(s[q - 1]).focus()
                }(/(13|32)/.test(b.keyCode.toString(10)) || /(^9$)/.test(b.keyCode.toString(10)) && o.options.selectOnTab) && l && (/(32)/.test(b.keyCode.toString(10)) || b.preventDefault(), o.options.liveSearch ? /(32)/.test(b.keyCode.toString(10)) || (o.$menu.find(".active a").click(), m.focus()) : a(":focus").click(), a(document).data("keycount", 0)), (/(^9$|27)/.test(b.keyCode.toString(10)) && l && (o.multiple || o.options.liveSearch) || /(27)/.test(b.keyCode.toString(10)) && !l) && (o.$menu.parent().removeClass("open"), o.$button.focus())
            }
        },
        mobile: function() {
            this.$element.addClass("mobile-device").appendTo(this.$newElement), this.options.container && this.$menu.hide()
        },
        refresh: function() {
            this.$lis = null, this.reloadLi(), this.render(), this.setWidth(), this.setStyle(), this.checkDisabled(), this.liHeight()
        },
        update: function() {
            this.reloadLi(), this.setWidth(), this.setStyle(), this.checkDisabled(), this.liHeight()
        },
        hide: function() {
            this.$newElement.hide()
        },
        show: function() {
            this.$newElement.show()
        },
        remove: function() {
            this.$newElement.remove(), this.$element.remove()
        }
    };
    var f = a.fn.selectpicker;
    a.fn.selectpicker = d, a.fn.selectpicker.Constructor = e, a.fn.selectpicker.noConflict = function() {
        return a.fn.selectpicker = f, this
    }, a(document).data("keycount", 0).on("keydown", ".bootstrap-select [data-toggle=dropdown], .bootstrap-select [role=menu], .bs-searchbox input", e.prototype.keydown).on("focusin.modal", ".bootstrap-select [data-toggle=dropdown], .bootstrap-select [role=menu], .bs-searchbox input", function(a) {
        a.stopPropagation()
    }), a(window).on("load.bs.select.data-api", function() {
        a(".selectpicker").each(function() {
            var b = a(this);
            d.call(b, b.data())
        })
        $( document ).ajaxStop(function() {
            console.log("wefwe")
            a(".selectpicker").each(function() {
                var b = a(this);
                d.call(b, b.data())
            })
        });
    })
}(jQuery);











(function() {
    function require(name) {
        var module = require.modules[name];
        if (!module) throw new Error('failed to require "' + name + '"');
        if (!("exports" in module) && typeof module.definition === "function") {
            module.client = module.component = true;
            module.definition.call(this, module.exports = {}, module);
            delete module.definition
        }
        return module.exports
    }
    require.loader = "component";
    require.helper = {};
    require.helper.semVerSort = function(a, b) {
        var aArray = a.version.split(".");
        var bArray = b.version.split(".");
        for (var i = 0; i < aArray.length; ++i) {
            var aInt = parseInt(aArray[i], 10);
            var bInt = parseInt(bArray[i], 10);
            if (aInt === bInt) {
                var aLex = aArray[i].substr(("" + aInt).length);
                var bLex = bArray[i].substr(("" + bInt).length);
                if (aLex === "" && bLex !== "") return 1;
                if (aLex !== "" && bLex === "") return -1;
                if (aLex !== "" && bLex !== "") return aLex > bLex ? 1 : -1;
                continue
            } else if (aInt > bInt) {
                return 1
            } else {
                return -1
            }
        }
        return 0
    };
    require.latest = function(name, returnPath) {
        function showError(name) {
            throw new Error('failed to find latest module of "' + name + '"')
        }
        var versionRegexp = /(.*)~(.*)@v?(\d+\.\d+\.\d+[^\/]*)$/;
        var remoteRegexp = /(.*)~(.*)/;
        if (!remoteRegexp.test(name)) showError(name);
        var moduleNames = Object.keys(require.modules);
        var semVerCandidates = [];
        var otherCandidates = [];
        for (var i = 0; i < moduleNames.length; i++) {
            var moduleName = moduleNames[i];
            if (new RegExp(name + "@").test(moduleName)) {
                var version = moduleName.substr(name.length + 1);
                var semVerMatch = versionRegexp.exec(moduleName);
                if (semVerMatch != null) {
                    semVerCandidates.push({
                        version: version,
                        name: moduleName
                    })
                } else {
                    otherCandidates.push({
                        version: version,
                        name: moduleName
                    })
                }
            }
        }
        if (semVerCandidates.concat(otherCandidates).length === 0) {
            showError(name)
        }
        if (semVerCandidates.length > 0) {
            var module = semVerCandidates.sort(require.helper.semVerSort).pop().name;
            if (returnPath === true) {
                return module
            }
            return require(module)
        }
        var module = otherCandidates.pop().name;
        if (returnPath === true) {
            return module
        }
        return require(module)
    };
    require.modules = {};
    require.register = function(name, definition) {
        require.modules[name] = {
            definition: definition
        }
    };
    require.define = function(name, exports) {
        require.modules[name] = {
            exports: exports
        }
    };
    require.register("abpetkov~transitionize@0.0.3", function(exports, module) {
        module.exports = Transitionize;

        function Transitionize(element, props) {
            if (!(this instanceof Transitionize)) return new Transitionize(element, props);
            this.element = element;
            this.props = props || {};
            this.init()
        }
        Transitionize.prototype.isSafari = function() {
            return /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor)
        };
        Transitionize.prototype.init = function() {
            var transitions = [];
            for (var key in this.props) {
                transitions.push(key + " " + this.props[key])
            }
            this.element.style.transition = transitions.join(", ");
            if (this.isSafari()) this.element.style.webkitTransition = transitions.join(", ")
        }
    });
    require.register("ftlabs~fastclick@v0.6.11", function(exports, module) {
        function FastClick(layer) {
            "use strict";
            var oldOnClick, self = this;
            this.trackingClick = false;
            this.trackingClickStart = 0;
            this.targetElement = null;
            this.touchStartX = 0;
            this.touchStartY = 0;
            this.lastTouchIdentifier = 0;
            this.touchBoundary = 10;
            this.layer = layer;
            if (!layer || !layer.nodeType) {
                throw new TypeError("Layer must be a document node")
            }
            this.onClick = function() {
                return FastClick.prototype.onClick.apply(self, arguments)
            };
            this.onMouse = function() {
                return FastClick.prototype.onMouse.apply(self, arguments)
            };
            this.onTouchStart = function() {
                return FastClick.prototype.onTouchStart.apply(self, arguments)
            };
            this.onTouchMove = function() {
                return FastClick.prototype.onTouchMove.apply(self, arguments)
            };
            this.onTouchEnd = function() {
                return FastClick.prototype.onTouchEnd.apply(self, arguments)
            };
            this.onTouchCancel = function() {
                return FastClick.prototype.onTouchCancel.apply(self, arguments)
            };
            if (FastClick.notNeeded(layer)) {
                return
            }
            if (this.deviceIsAndroid) {
                layer.addEventListener("mouseover", this.onMouse, true);
                layer.addEventListener("mousedown", this.onMouse, true);
                layer.addEventListener("mouseup", this.onMouse, true)
            }
            layer.addEventListener("click", this.onClick, true);
            layer.addEventListener("touchstart", this.onTouchStart, false);
            layer.addEventListener("touchmove", this.onTouchMove, false);
            layer.addEventListener("touchend", this.onTouchEnd, false);
            layer.addEventListener("touchcancel", this.onTouchCancel, false);
            if (!Event.prototype.stopImmediatePropagation) {
                layer.removeEventListener = function(type, callback, capture) {
                    var rmv = Node.prototype.removeEventListener;
                    if (type === "click") {
                        rmv.call(layer, type, callback.hijacked || callback, capture)
                    } else {
                        rmv.call(layer, type, callback, capture)
                    }
                };
                layer.addEventListener = function(type, callback, capture) {
                    var adv = Node.prototype.addEventListener;
                    if (type === "click") {
                        adv.call(layer, type, callback.hijacked || (callback.hijacked = function(event) {
                            if (!event.propagationStopped) {
                                callback(event)
                            }
                        }), capture)
                    } else {
                        adv.call(layer, type, callback, capture)
                    }
                }
            }
            if (typeof layer.onclick === "function") {
                oldOnClick = layer.onclick;
                layer.addEventListener("click", function(event) {
                    oldOnClick(event)
                }, false);
                layer.onclick = null
            }
        }
        FastClick.prototype.deviceIsAndroid = navigator.userAgent.indexOf("Android") > 0;
        FastClick.prototype.deviceIsIOS = /iP(ad|hone|od)/.test(navigator.userAgent);
        FastClick.prototype.deviceIsIOS4 = FastClick.prototype.deviceIsIOS && /OS 4_\d(_\d)?/.test(navigator.userAgent);
        FastClick.prototype.deviceIsIOSWithBadTarget = FastClick.prototype.deviceIsIOS && /OS ([6-9]|\d{2})_\d/.test(navigator.userAgent);
        FastClick.prototype.needsClick = function(target) {
            "use strict";
            switch (target.nodeName.toLowerCase()) {
                case "button":
                case "select":
                case "textarea":
                    if (target.disabled) {
                        return true
                    }
                    break;
                case "input":
                    if (this.deviceIsIOS && target.type === "file" || target.disabled) {
                        return true
                    }
                    break;
                case "label":
                case "video":
                    return true
            }
            return /\bneedsclick\b/.test(target.className)
        };
        FastClick.prototype.needsFocus = function(target) {
            "use strict";
            switch (target.nodeName.toLowerCase()) {
                case "textarea":
                    return true;
                case "select":
                    return !this.deviceIsAndroid;
                case "input":
                    switch (target.type) {
                        case "button":
                        case "checkbox":
                        case "file":
                        case "image":
                        case "radio":
                        case "submit":
                            return false
                    }
                    return !target.disabled && !target.readOnly;
                default:
                    return /\bneedsfocus\b/.test(target.className)
            }
        };
        FastClick.prototype.sendClick = function(targetElement, event) {
            "use strict";
            var clickEvent, touch;
            if (document.activeElement && document.activeElement !== targetElement) {
                document.activeElement.blur()
            }
            touch = event.changedTouches[0];
            clickEvent = document.createEvent("MouseEvents");
            clickEvent.initMouseEvent(this.determineEventType(targetElement), true, true, window, 1, touch.screenX, touch.screenY, touch.clientX, touch.clientY, false, false, false, false, 0, null);
            clickEvent.forwardedTouchEvent = true;
            targetElement.dispatchEvent(clickEvent)
        };
        FastClick.prototype.determineEventType = function(targetElement) {
            "use strict";
            if (this.deviceIsAndroid && targetElement.tagName.toLowerCase() === "select") {
                return "mousedown"
            }
            return "click"
        };
        FastClick.prototype.focus = function(targetElement) {
            "use strict";
            var length;
            if (this.deviceIsIOS && targetElement.setSelectionRange && targetElement.type.indexOf("date") !== 0 && targetElement.type !== "time") {
                length = targetElement.value.length;
                targetElement.setSelectionRange(length, length)
            } else {
                targetElement.focus()
            }
        };
        FastClick.prototype.updateScrollParent = function(targetElement) {
            "use strict";
            var scrollParent, parentElement;
            scrollParent = targetElement.fastClickScrollParent;
            if (!scrollParent || !scrollParent.contains(targetElement)) {
                parentElement = targetElement;
                do {
                    if (parentElement.scrollHeight > parentElement.offsetHeight) {
                        scrollParent = parentElement;
                        targetElement.fastClickScrollParent = parentElement;
                        break
                    }
                    parentElement = parentElement.parentElement
                } while (parentElement)
            }
            if (scrollParent) {
                scrollParent.fastClickLastScrollTop = scrollParent.scrollTop
            }
        };
        FastClick.prototype.getTargetElementFromEventTarget = function(eventTarget) {
            "use strict";
            if (eventTarget.nodeType === Node.TEXT_NODE) {
                return eventTarget.parentNode
            }
            return eventTarget
        };
        FastClick.prototype.onTouchStart = function(event) {
            "use strict";
            var targetElement, touch, selection;
            if (event.targetTouches.length > 1) {
                return true
            }
            targetElement = this.getTargetElementFromEventTarget(event.target);
            touch = event.targetTouches[0];
            if (this.deviceIsIOS) {
                selection = window.getSelection();
                if (selection.rangeCount && !selection.isCollapsed) {
                    return true
                }
                if (!this.deviceIsIOS4) {
                    if (touch.identifier === this.lastTouchIdentifier) {
                        event.preventDefault();
                        return false
                    }
                    this.lastTouchIdentifier = touch.identifier;
                    this.updateScrollParent(targetElement)
                }
            }
            this.trackingClick = true;
            this.trackingClickStart = event.timeStamp;
            this.targetElement = targetElement;
            this.touchStartX = touch.pageX;
            this.touchStartY = touch.pageY;
            if (event.timeStamp - this.lastClickTime < 200) {
                event.preventDefault()
            }
            return true
        };
        FastClick.prototype.touchHasMoved = function(event) {
            "use strict";
            var touch = event.changedTouches[0],
                boundary = this.touchBoundary;
            if (Math.abs(touch.pageX - this.touchStartX) > boundary || Math.abs(touch.pageY - this.touchStartY) > boundary) {
                return true
            }
            return false
        };
        FastClick.prototype.onTouchMove = function(event) {
            "use strict";
            if (!this.trackingClick) {
                return true
            }
            if (this.targetElement !== this.getTargetElementFromEventTarget(event.target) || this.touchHasMoved(event)) {
                this.trackingClick = false;
                this.targetElement = null
            }
            return true
        };
        FastClick.prototype.findControl = function(labelElement) {
            "use strict";
            if (labelElement.control !== undefined) {
                return labelElement.control
            }
            if (labelElement.htmlFor) {
                return document.getElementById(labelElement.htmlFor)
            }
            return labelElement.querySelector("button, input:not([type=hidden]), keygen, meter, output, progress, select, textarea")
        };
        FastClick.prototype.onTouchEnd = function(event) {
            "use strict";
            var forElement, trackingClickStart, targetTagName, scrollParent, touch, targetElement = this.targetElement;
            if (!this.trackingClick) {
                return true
            }
            if (event.timeStamp - this.lastClickTime < 200) {
                this.cancelNextClick = true;
                return true
            }
            this.cancelNextClick = false;
            this.lastClickTime = event.timeStamp;
            trackingClickStart = this.trackingClickStart;
            this.trackingClick = false;
            this.trackingClickStart = 0;
            if (this.deviceIsIOSWithBadTarget) {
                touch = event.changedTouches[0];
                targetElement = document.elementFromPoint(touch.pageX - window.pageXOffset, touch.pageY - window.pageYOffset) || targetElement;
                targetElement.fastClickScrollParent = this.targetElement.fastClickScrollParent
            }
            targetTagName = targetElement.tagName.toLowerCase();
            if (targetTagName === "label") {
                forElement = this.findControl(targetElement);
                if (forElement) {
                    this.focus(targetElement);
                    if (this.deviceIsAndroid) {
                        return false
                    }
                    targetElement = forElement
                }
            } else if (this.needsFocus(targetElement)) {
                if (event.timeStamp - trackingClickStart > 100 || this.deviceIsIOS && window.top !== window && targetTagName === "input") {
                    this.targetElement = null;
                    return false
                }
                this.focus(targetElement);
                if (!this.deviceIsIOS4 || targetTagName !== "select") {
                    this.targetElement = null;
                    event.preventDefault()
                }
                return false
            }
            if (this.deviceIsIOS && !this.deviceIsIOS4) {
                scrollParent = targetElement.fastClickScrollParent;
                if (scrollParent && scrollParent.fastClickLastScrollTop !== scrollParent.scrollTop) {
                    return true
                }
            }
            if (!this.needsClick(targetElement)) {
                event.preventDefault();
                this.sendClick(targetElement, event)
            }
            return false
        };
        FastClick.prototype.onTouchCancel = function() {
            "use strict";
            this.trackingClick = false;
            this.targetElement = null
        };
        FastClick.prototype.onMouse = function(event) {
            "use strict";
            if (!this.targetElement) {
                return true
            }
            if (event.forwardedTouchEvent) {
                return true
            }
            if (!event.cancelable) {
                return true
            }
            if (!this.needsClick(this.targetElement) || this.cancelNextClick) {
                if (event.stopImmediatePropagation) {
                    event.stopImmediatePropagation()
                } else {
                    event.propagationStopped = true
                }
                event.stopPropagation();
                event.preventDefault();
                return false
            }
            return true
        };
        FastClick.prototype.onClick = function(event) {
            "use strict";
            var permitted;
            if (this.trackingClick) {
                this.targetElement = null;
                this.trackingClick = false;
                return true
            }
            if (event.target.type === "submit" && event.detail === 0) {
                return true
            }
            permitted = this.onMouse(event);
            if (!permitted) {
                this.targetElement = null
            }
            return permitted
        };
        FastClick.prototype.destroy = function() {
            "use strict";
            var layer = this.layer;
            if (this.deviceIsAndroid) {
                layer.removeEventListener("mouseover", this.onMouse, true);
                layer.removeEventListener("mousedown", this.onMouse, true);
                layer.removeEventListener("mouseup", this.onMouse, true)
            }
            layer.removeEventListener("click", this.onClick, true);
            layer.removeEventListener("touchstart", this.onTouchStart, false);
            layer.removeEventListener("touchmove", this.onTouchMove, false);
            layer.removeEventListener("touchend", this.onTouchEnd, false);
            layer.removeEventListener("touchcancel", this.onTouchCancel, false)
        };
        FastClick.notNeeded = function(layer) {
            "use strict";
            var metaViewport;
            var chromeVersion;
            if (typeof window.ontouchstart === "undefined") {
                return true
            }
            chromeVersion = +(/Chrome\/([0-9]+)/.exec(navigator.userAgent) || [, 0])[1];
            if (chromeVersion) {
                if (FastClick.prototype.deviceIsAndroid) {
                    metaViewport = document.querySelector("meta[name=viewport]");
                    if (metaViewport) {
                        if (metaViewport.content.indexOf("user-scalable=no") !== -1) {
                            return true
                        }
                        if (chromeVersion > 31 && window.innerWidth <= window.screen.width) {
                            return true
                        }
                    }
                } else {
                    return true
                }
            }
            if (layer.style.msTouchAction === "none") {
                return true
            }
            return false
        };
        FastClick.attach = function(layer) {
            "use strict";
            return new FastClick(layer)
        };
        if (typeof define !== "undefined" && define.amd) {
            define(function() {
                "use strict";
                return FastClick
            })
        } else if (typeof module !== "undefined" && module.exports) {
            module.exports = FastClick.attach;
            module.exports.FastClick = FastClick
        } else {
            window.FastClick = FastClick
        }
    });
    require.register("component~indexof@0.0.3", function(exports, module) {
        module.exports = function(arr, obj) {
            if (arr.indexOf) return arr.indexOf(obj);
            for (var i = 0; i < arr.length; ++i) {
                if (arr[i] === obj) return i
            }
            return -1
        }
    });
    require.register("component~classes@1.2.1", function(exports, module) {
        var index = require("component~indexof@0.0.3");
        var re = /\s+/;
        var toString = Object.prototype.toString;
        module.exports = function(el) {
            return new ClassList(el)
        };

        function ClassList(el) {
            if (!el) throw new Error("A DOM element reference is required");
            this.el = el;
            this.list = el.classList
        }
        ClassList.prototype.add = function(name) {
            if (this.list) {
                this.list.add(name);
                return this
            }
            var arr = this.array();
            var i = index(arr, name);
            if (!~i) arr.push(name);
            this.el.className = arr.join(" ");
            return this
        };
        ClassList.prototype.remove = function(name) {
            if ("[object RegExp]" == toString.call(name)) {
                return this.removeMatching(name)
            }
            if (this.list) {
                this.list.remove(name);
                return this
            }
            var arr = this.array();
            var i = index(arr, name);
            if (~i) arr.splice(i, 1);
            this.el.className = arr.join(" ");
            return this
        };
        ClassList.prototype.removeMatching = function(re) {
            var arr = this.array();
            for (var i = 0; i < arr.length; i++) {
                if (re.test(arr[i])) {
                    this.remove(arr[i])
                }
            }
            return this
        };
        ClassList.prototype.toggle = function(name, force) {
            if (this.list) {
                if ("undefined" !== typeof force) {
                    if (force !== this.list.toggle(name, force)) {
                        this.list.toggle(name)
                    }
                } else {
                    this.list.toggle(name)
                }
                return this
            }
            if ("undefined" !== typeof force) {
                if (!force) {
                    this.remove(name)
                } else {
                    this.add(name)
                }
            } else {
                if (this.has(name)) {
                    this.remove(name)
                } else {
                    this.add(name)
                }
            }
            return this
        };
        ClassList.prototype.array = function() {
            var str = this.el.className.replace(/^\s+|\s+$/g, "");
            var arr = str.split(re);
            if ("" === arr[0]) arr.shift();
            return arr
        };
        ClassList.prototype.has = ClassList.prototype.contains = function(name) {
            return this.list ? this.list.contains(name) : !!~index(this.array(), name)
        }
    });
    require.register("switchery", function(exports, module) {
        var transitionize = require("abpetkov~transitionize@0.0.3"),
            fastclick = require("ftlabs~fastclick@v0.6.11"),
            classes = require("component~classes@1.2.1");
        module.exports = Switchery;
        var defaults = {
            color: "#64bd63",
            secondaryColor: "#dfdfdf",
            jackColor: "#fff",
            className: "switchery",
            disabled: false,
            disabledOpacity: .5,
            speed: "0.4s",
            size: "default"
        };

        function Switchery(element, options) {
            if (!(this instanceof Switchery)) return new Switchery(element, options);
            this.element = element;
            this.options = options || {};
            for (var i in defaults) {
                if (this.options[i] == null) {
                    this.options[i] = defaults[i]
                }
            }
            if (this.element != null && this.element.type == "checkbox") this.init()
        }
        Switchery.prototype.hide = function() {
            this.element.style.display = "none"
        };
        Switchery.prototype.show = function() {
            var switcher = this.create();
            this.insertAfter(this.element, switcher)
        };
        Switchery.prototype.create = function() {
            this.switcher = document.createElement("span");
            this.jack = document.createElement("small");
            this.switcher.appendChild(this.jack);
            this.switcher.className = this.options.className;
            return this.switcher
        };
        Switchery.prototype.insertAfter = function(reference, target) {
            reference.parentNode.insertBefore(target, reference.nextSibling)
        };
        Switchery.prototype.isChecked = function() {
            return this.element.checked
        };
        Switchery.prototype.isDisabled = function() {
            return this.options.disabled || this.element.disabled || this.element.readOnly
        };
        Switchery.prototype.setPosition = function(clicked) {
            var checked = this.isChecked(),
                switcher = this.switcher,
                jack = this.jack;
            if (clicked && checked) checked = false;
            else if (clicked && !checked) checked = true;
            if (checked === true) {
                this.element.checked = true;
                if (window.getComputedStyle) jack.style.left = parseInt(window.getComputedStyle(switcher).width) - parseInt(window.getComputedStyle(jack).width) + "px";
                else jack.style.left = parseInt(switcher.currentStyle["width"]) - parseInt(jack.currentStyle["width"]) + "px"; if (this.options.color) this.colorize();
                this.setSpeed()
            } else {
                jack.style.left = 0;
                this.element.checked = false;
                this.switcher.style.boxShadow = "inset 0 0 0 0 " + this.options.secondaryColor;
                this.switcher.style.borderColor = this.options.secondaryColor;
                this.switcher.style.backgroundColor = this.options.secondaryColor !== defaults.secondaryColor ? this.options.secondaryColor : "#fff";
                this.jack.style.backgroundColor = this.options.jackColor;
                this.setSpeed()
            }
        };
        Switchery.prototype.setSpeed = function() {
            var switcherProp = {},
                jackProp = {
                    left: this.options.speed.replace(/[a-z]/, "") / 2 + "s"
                };
            if (this.isChecked()) {
                switcherProp = {
                    border: this.options.speed,
                    "box-shadow": this.options.speed,
                    "background-color": this.options.speed.replace(/[a-z]/, "") * 3 + "s"
                }
            } else {
                switcherProp = {
                    border: this.options.speed,
                    "box-shadow": this.options.speed
                }
            }
            transitionize(this.switcher, switcherProp);
            transitionize(this.jack, jackProp)
        };
        Switchery.prototype.setSize = function() {
            var small = "switchery-small",
                normal = "switchery-default",
                large = "switchery-large";
            switch (this.options.size) {
                case "small":
                    classes(this.switcher).add(small);
                    break;
                case "large":
                    classes(this.switcher).add(large);
                    break;
                default:
                    classes(this.switcher).add(normal);
                    break
            }
        };
        Switchery.prototype.colorize = function() {
            var switcherHeight = this.switcher.offsetHeight / 2;
            this.switcher.style.backgroundColor = this.options.color;
            this.switcher.style.borderColor = this.options.color;
            this.switcher.style.boxShadow = "inset 0 0 0 " + switcherHeight + "px " + this.options.color;
            this.jack.style.backgroundColor = this.options.jackColor
        };
        Switchery.prototype.handleOnchange = function(state) {
            if (document.dispatchEvent) {
                var event = document.createEvent("HTMLEvents");
                event.initEvent("change", true, true);
                this.element.dispatchEvent(event)
            } else {
                this.element.fireEvent("onchange")
            }
        };
        Switchery.prototype.handleChange = function() {
            var self = this,
                el = this.element;
            if (el.addEventListener) {
                el.addEventListener("change", function() {
                    self.setPosition()
                })
            } else {
                el.attachEvent("onchange", function() {
                    self.setPosition()
                })
            }
        };
        Switchery.prototype.handleClick = function() {
            var self = this,
                switcher = this.switcher,
                parent = self.element.parentNode.tagName.toLowerCase(),
                labelParent = parent === "label" ? false : true;
            if (this.isDisabled() === false) {
                fastclick(switcher);
                if (switcher.addEventListener) {
                    switcher.addEventListener("click", function(e) {
                        self.setPosition(labelParent);
                        self.handleOnchange(self.element.checked)
                    })
                } else {
                    switcher.attachEvent("onclick", function() {
                        self.setPosition(labelParent);
                        self.handleOnchange(self.element.checked)
                    })
                }
            } else {
                this.element.disabled = true;
                this.switcher.style.opacity = this.options.disabledOpacity
            }
        };
        Switchery.prototype.markAsSwitched = function() {
            this.element.setAttribute("data-switchery", true)
        };
        Switchery.prototype.markedAsSwitched = function() {
            return this.element.getAttribute("data-switchery")
        };
        Switchery.prototype.init = function() {
            this.hide();
            this.show();
            this.setSize();
            this.setPosition();
            this.markAsSwitched();
            this.handleChange();
            this.handleClick()
        }
    });
    if (typeof exports == "object") {
        module.exports = require("switchery")
    } else if (typeof define == "function" && define.amd) {
        define("Switchery", [], function() {
            return require("switchery")
        })
    } else {
        (this || window)["Switchery"] = require("switchery")
    }
})(); /*! nanoScrollerJS - v0.8.4 - (c) 2014 James Florentino; Licensed MIT */


! function(a, b, c) {
    "use strict";
    var d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H;
    z = {
        paneClass: "nano-pane",
        sliderClass: "nano-slider",
        contentClass: "nano-content",
        iOSNativeScrolling: !1,
        preventPageScrolling: !1,
        disableResize: !1,
        alwaysVisible: !1,
        flashDelay: 1500,
        sliderMinHeight: 20,
        sliderMaxHeight: null,
        documentContext: null,
        windowContext: null
    }, u = "scrollbar", t = "scroll", l = "mousedown", m = "mouseenter", n = "mousemove", p = "mousewheel", o = "mouseup", s = "resize", h = "drag", i = "enter", w = "up", r = "panedown", f = "DOMMouseScroll", g = "down", x = "wheel", j = "keydown", k = "keyup", v = "touchmove", d = "Microsoft Internet Explorer" === b.navigator.appName && /msie 7./i.test(b.navigator.appVersion) && b.ActiveXObject, e = null, D = b.requestAnimationFrame, y = b.cancelAnimationFrame, F = c.createElement("div").style, H = function() {
        var a, b, c, d, e, f;
        for (d = ["t", "webkitT", "MozT", "msT", "OT"], a = e = 0, f = d.length; f > e; a = ++e)
            if (c = d[a], b = d[a] + "ransform", b in F) return d[a].substr(0, d[a].length - 1);
        return !1
    }(), G = function(a) {
        return H === !1 ? !1 : "" === H ? a : H + a.charAt(0).toUpperCase() + a.substr(1)
    }, E = G("transform"), B = E !== !1, A = function() {
        var a, b, d;
        return a = c.createElement("div"), b = a.style, b.position = "absolute", b.width = "100px", b.height = "100px", b.overflow = t, b.top = "-9999px", c.body.appendChild(a), d = a.offsetWidth - a.clientWidth, c.body.removeChild(a), d
    }, C = function() {
        var a, c, d;
        return c = b.navigator.userAgent, (a = /(?=.+Mac OS X)(?=.+Firefox)/.test(c)) ? (d = /Firefox\/\d{2}\./.exec(c), d && (d = d[0].replace(/\D+/g, "")), a && +d > 23) : !1
    }, q = function() {
        function j(d, f) {
            this.el = d, this.options = f, e || (e = A()), this.$el = a(this.el), this.doc = a(this.options.documentContext || c), this.win = a(this.options.windowContext || b), this.body = this.doc.find("body"), this.$content = this.$el.children("." + f.contentClass), this.$content.attr("tabindex", this.options.tabIndex || 0), this.content = this.$content[0], this.previousPosition = 0, this.options.iOSNativeScrolling && null != this.el.style.WebkitOverflowScrolling ? this.nativeScrolling() : this.generate(), this.createEvents(), this.addEvents(), this.reset()
        }
        return j.prototype.preventScrolling = function(a, b) {
            if (this.isActive)
                if (a.type === f)(b === g && a.originalEvent.detail > 0 || b === w && a.originalEvent.detail < 0) && a.preventDefault();
                else if (a.type === p) {
                if (!a.originalEvent || !a.originalEvent.wheelDelta) return;
                (b === g && a.originalEvent.wheelDelta < 0 || b === w && a.originalEvent.wheelDelta > 0) && a.preventDefault()
            }
        }, j.prototype.nativeScrolling = function() {
            this.$content.css({
                WebkitOverflowScrolling: "touch"
            }), this.iOSNativeScrolling = !0, this.isActive = !0
        }, j.prototype.updateScrollValues = function() {
            var a, b;
            a = this.content, this.maxScrollTop = a.scrollHeight - a.clientHeight, this.prevScrollTop = this.contentScrollTop || 0, this.contentScrollTop = a.scrollTop, b = this.contentScrollTop > this.previousPosition ? "down" : this.contentScrollTop < this.previousPosition ? "up" : "same", this.previousPosition = this.contentScrollTop, "same" !== b && this.$el.trigger("update", {
                position: this.contentScrollTop,
                maximum: this.maxScrollTop,
                direction: b
            }), this.iOSNativeScrolling || (this.maxSliderTop = this.paneHeight - this.sliderHeight, this.sliderTop = 0 === this.maxScrollTop ? 0 : this.contentScrollTop * this.maxSliderTop / this.maxScrollTop)
        }, j.prototype.setOnScrollStyles = function() {
            var a;
            B ? (a = {}, a[E] = "translate(0, " + this.sliderTop + "px)") : a = {
                top: this.sliderTop
            }, D ? (y && this.scrollRAF && y(this.scrollRAF), this.scrollRAF = D(function(b) {
                return function() {
                    return b.scrollRAF = null, b.slider.css(a)
                }
            }(this))) : this.slider.css(a)
        }, j.prototype.createEvents = function() {
            this.events = {
                down: function(a) {
                    return function(b) {
                        return a.isBeingDragged = !0, a.offsetY = b.pageY - a.slider.offset().top, a.slider.is(b.target) || (a.offsetY = 0), a.pane.addClass("active"), a.doc.bind(n, a.events[h]).bind(o, a.events[w]), a.body.bind(m, a.events[i]), !1
                    }
                }(this),
                drag: function(a) {
                    return function(b) {
                        return a.sliderY = b.pageY - a.$el.offset().top - a.paneTop - (a.offsetY || .5 * a.sliderHeight), a.scroll(), a.contentScrollTop >= a.maxScrollTop && a.prevScrollTop !== a.maxScrollTop ? a.$el.trigger("scrollend") : 0 === a.contentScrollTop && 0 !== a.prevScrollTop && a.$el.trigger("scrolltop"), !1
                    }
                }(this),
                up: function(a) {
                    return function() {
                        return a.isBeingDragged = !1, a.pane.removeClass("active"), a.doc.unbind(n, a.events[h]).unbind(o, a.events[w]), a.body.unbind(m, a.events[i]), !1
                    }
                }(this),
                resize: function(a) {
                    return function() {
                        a.reset()
                    }
                }(this),
                panedown: function(a) {
                    return function(b) {
                        return a.sliderY = (b.offsetY || b.originalEvent.layerY) - .5 * a.sliderHeight, a.scroll(), a.events.down(b), !1
                    }
                }(this),
                scroll: function(a) {
                    return function(b) {
                        a.updateScrollValues(), a.isBeingDragged || (a.iOSNativeScrolling || (a.sliderY = a.sliderTop, a.setOnScrollStyles()), null != b && (a.contentScrollTop >= a.maxScrollTop ? (a.options.preventPageScrolling && a.preventScrolling(b, g), a.prevScrollTop !== a.maxScrollTop && a.$el.trigger("scrollend")) : 0 === a.contentScrollTop && (a.options.preventPageScrolling && a.preventScrolling(b, w), 0 !== a.prevScrollTop && a.$el.trigger("scrolltop"))))
                    }
                }(this),
                wheel: function(a) {
                    return function(b) {
                        var c;
                        if (null != b) return c = b.delta || b.wheelDelta || b.originalEvent && b.originalEvent.wheelDelta || -b.detail || b.originalEvent && -b.originalEvent.detail, c && (a.sliderY += -c / 3), a.scroll(), !1
                    }
                }(this),
                enter: function(a) {
                    return function(b) {
                        var c;
                        if (a.isBeingDragged) return 1 !== (b.buttons || b.which) ? (c = a.events)[w].apply(c, arguments) : void 0
                    }
                }(this)
            }
        }, j.prototype.addEvents = function() {
            var a;
            this.removeEvents(), a = this.events, this.options.disableResize || this.win.bind(s, a[s]), this.iOSNativeScrolling || (this.slider.bind(l, a[g]), this.pane.bind(l, a[r]).bind("" + p + " " + f, a[x])), this.$content.bind("" + t + " " + p + " " + f + " " + v, a[t])
        }, j.prototype.removeEvents = function() {
            var a;
            a = this.events, this.win.unbind(s, a[s]), this.iOSNativeScrolling || (this.slider.unbind(), this.pane.unbind()), this.$content.unbind("" + t + " " + p + " " + f + " " + v, a[t])
        }, j.prototype.generate = function() {
            var a, c, d, f, g, h, i;
            return f = this.options, h = f.paneClass, i = f.sliderClass, a = f.contentClass, (g = this.$el.children("." + h)).length || g.children("." + i).length || this.$el.append('<div class="' + h + '"><div class="' + i + '" /></div>'), this.pane = this.$el.children("." + h), this.slider = this.pane.find("." + i), 0 === e && C() ? (d = b.getComputedStyle(this.content, null).getPropertyValue("padding-right").replace(/[^0-9.]+/g, ""), c = {
                right: -14,
                paddingRight: +d + 14
            }) : e && (c = {
                right: -e
            }, this.$el.addClass("has-scrollbar")), null != c && this.$content.css(c), this
        }, j.prototype.restore = function() {
            this.stopped = !1, this.iOSNativeScrolling || this.pane.show(), this.addEvents()
        }, j.prototype.reset = function() {
            var a, b, c, f, g, h, i, j, k, l, m, n;
            return this.iOSNativeScrolling ? void(this.contentHeight = this.content.scrollHeight) : (this.$el.find("." + this.options.paneClass).length || this.generate().stop(), this.stopped && this.restore(), a = this.content, f = a.style, g = f.overflowY, d && this.$content.css({
                height: this.$content.height()
            }), b = a.scrollHeight + e, l = parseInt(this.$el.css("max-height"), 10), l > 0 && (this.$el.height(""), this.$el.height(a.scrollHeight > l ? l : a.scrollHeight)), i = this.pane.outerHeight(!1), k = parseInt(this.pane.css("top"), 10), h = parseInt(this.pane.css("bottom"), 10), j = i + k + h, n = Math.round(j / b * j), n < this.options.sliderMinHeight ? n = this.options.sliderMinHeight : null != this.options.sliderMaxHeight && n > this.options.sliderMaxHeight && (n = this.options.sliderMaxHeight), g === t && f.overflowX !== t && (n += e), this.maxSliderTop = j - n, this.contentHeight = b, this.paneHeight = i, this.paneOuterHeight = j, this.sliderHeight = n, this.paneTop = k, this.slider.height(n), this.events.scroll(), this.pane.show(), this.isActive = !0, a.scrollHeight === a.clientHeight || this.pane.outerHeight(!0) >= a.scrollHeight && g !== t ? (this.pane.hide(), this.isActive = !1) : this.el.clientHeight === a.scrollHeight && g === t ? this.slider.hide() : this.slider.show(), this.pane.css({
                opacity: this.options.alwaysVisible ? 1 : "",
                visibility: this.options.alwaysVisible ? "visible" : ""
            }), c = this.$content.css("position"), ("static" === c || "relative" === c) && (m = parseInt(this.$content.css("right"), 10), m && this.$content.css({
                right: "",
                marginRight: m
            })), this)
        }, j.prototype.scroll = function() {
            return this.isActive ? (this.sliderY = Math.max(0, this.sliderY), this.sliderY = Math.min(this.maxSliderTop, this.sliderY), this.$content.scrollTop(this.maxScrollTop * this.sliderY / this.maxSliderTop), this.iOSNativeScrolling || (this.updateScrollValues(), this.setOnScrollStyles()), this) : void 0
        }, j.prototype.scrollBottom = function(a) {
            return this.isActive ? (this.$content.scrollTop(this.contentHeight - this.$content.height() - a).trigger(p), this.stop().restore(), this) : void 0
        }, j.prototype.scrollTop = function(a) {
            return this.isActive ? (this.$content.scrollTop(+a).trigger(p), this.stop().restore(), this) : void 0
        }, j.prototype.scrollTo = function(a) {
            return this.isActive ? (this.scrollTop(this.$el.find(a).get(0).offsetTop), this) : void 0
        }, j.prototype.stop = function() {
            return y && this.scrollRAF && (y(this.scrollRAF), this.scrollRAF = null), this.stopped = !0, this.removeEvents(), this.iOSNativeScrolling || this.pane.hide(), this
        }, j.prototype.destroy = function() {
            return this.stopped || this.stop(), !this.iOSNativeScrolling && this.pane.length && this.pane.remove(), d && this.$content.height(""), this.$content.removeAttr("tabindex"), this.$el.hasClass("has-scrollbar") && (this.$el.removeClass("has-scrollbar"), this.$content.css({
                right: ""
            })), this
        }, j.prototype.flash = function() {
            return !this.iOSNativeScrolling && this.isActive ? (this.reset(), this.pane.addClass("flashed"), setTimeout(function(a) {
                return function() {
                    a.pane.removeClass("flashed")
                }
            }(this), this.options.flashDelay), this) : void 0
        }, j
    }(), a.fn.nanoScroller = function(b) {
        return this.each(function() {
            var c, d;
            if ((d = this.nanoscroller) || (c = a.extend({}, z, b), this.nanoscroller = d = new q(this, c)), b && "object" == typeof b) {
                if (a.extend(d.options, b), null != b.scrollBottom) return d.scrollBottom(b.scrollBottom);
                if (null != b.scrollTop) return d.scrollTop(b.scrollTop);
                if (b.scrollTo) return d.scrollTo(b.scrollTo);
                if ("bottom" === b.scroll) return d.scrollBottom(0);
                if ("top" === b.scroll) return d.scrollTop(0);
                if (b.scroll && b.scroll instanceof a) return d.scrollTo(b.scroll);
                if (b.stop) return d.stop();
                if (b.destroy) return d.destroy();
                if (b.flash) return d.flash()
            }
            return d.reset()
        })
    }, a.fn.nanoScroller.Constructor = q
}(jQuery, window, document);










/*! dropzone.js */
! function() {
    function a(b) {
        var c = a.modules[b];
        if (!c) throw new Error('failed to require "' + b + '"');
        return "exports" in c || "function" != typeof c.definition || (c.client = c.component = !0, c.definition.call(this, c.exports = {}, c), delete c.definition), c.exports
    }
    a.modules = {}, a.register = function(b, c) {
        a.modules[b] = {
            definition: c
        }
    }, a.define = function(b, c) {
        a.modules[b] = {
            exports: c
        }
    }, a.register("component~emitter@1.1.2", function(a, b) {
        function c(a) {
            return a ? d(a) : void 0
        }

        function d(a) {
            for (var b in c.prototype) a[b] = c.prototype[b];
            return a
        }
        b.exports = c, c.prototype.on = c.prototype.addEventListener = function(a, b) {
            return this._callbacks = this._callbacks || {}, (this._callbacks[a] = this._callbacks[a] || []).push(b), this
        }, c.prototype.once = function(a, b) {
            function c() {
                d.off(a, c), b.apply(this, arguments)
            }
            var d = this;
            return this._callbacks = this._callbacks || {}, c.fn = b, this.on(a, c), this
        }, c.prototype.off = c.prototype.removeListener = c.prototype.removeAllListeners = c.prototype.removeEventListener = function(a, b) {
            if (this._callbacks = this._callbacks || {}, 0 == arguments.length) return this._callbacks = {}, this;
            var c = this._callbacks[a];
            if (!c) return this;
            if (1 == arguments.length) return delete this._callbacks[a], this;
            for (var d, e = 0; e < c.length; e++)
                if (d = c[e], d === b || d.fn === b) {
                    c.splice(e, 1);
                    break
                }
            return this
        }, c.prototype.emit = function(a) {
            this._callbacks = this._callbacks || {};
            var b = [].slice.call(arguments, 1),
                c = this._callbacks[a];
            if (c) {
                c = c.slice(0);
                for (var d = 0, e = c.length; e > d; ++d) c[d].apply(this, b)
            }
            return this
        }, c.prototype.listeners = function(a) {
            return this._callbacks = this._callbacks || {}, this._callbacks[a] || []
        }, c.prototype.hasListeners = function(a) {
            return !!this.listeners(a).length
        }
    }), a.register("dropzone", function(b, c) {
        c.exports = a("dropzone/lib/dropzone.js")
    }), a.register("dropzone/lib/dropzone.js", function(b, c) {
        (function() {
            var b, d, e, f, g, h, i, j, k = {}.hasOwnProperty,
                l = function(a, b) {
                    function c() {
                        this.constructor = a
                    }
                    for (var d in b) k.call(b, d) && (a[d] = b[d]);
                    return c.prototype = b.prototype, a.prototype = new c, a.__super__ = b.prototype, a
                },
                m = [].slice;
            d = "undefined" != typeof Emitter && null !== Emitter ? Emitter : a("component~emitter@1.1.2"), i = function() {}, b = function(a) {
                function b(a, d) {
                    var e, f, g;
                    if (this.element = a, this.version = b.version, this.defaultOptions.previewTemplate = this.defaultOptions.previewTemplate.replace(/\n*/g, ""), this.clickableElements = [], this.listeners = [], this.files = [], "string" == typeof this.element && (this.element = document.querySelector(this.element)), !this.element || null == this.element.nodeType) throw new Error("Invalid dropzone element.");
                    if (this.element.dropzone) throw new Error("Dropzone already attached.");
                    if (b.instances.push(this), this.element.dropzone = this, e = null != (g = b.optionsForElement(this.element)) ? g : {}, this.options = c({}, this.defaultOptions, e, null != d ? d : {}), this.options.forceFallback || !b.isBrowserSupported()) return this.options.fallback.call(this);
                    if (null == this.options.url && (this.options.url = this.element.getAttribute("action")), !this.options.url) throw new Error("No URL provided.");
                    if (this.options.acceptedFiles && this.options.acceptedMimeTypes) throw new Error("You can't provide both 'acceptedFiles' and 'acceptedMimeTypes'. 'acceptedMimeTypes' is deprecated.");
                    this.options.acceptedMimeTypes && (this.options.acceptedFiles = this.options.acceptedMimeTypes, delete this.options.acceptedMimeTypes), this.options.method = this.options.method.toUpperCase(), (f = this.getExistingFallback()) && f.parentNode && f.parentNode.removeChild(f), this.options.previewsContainer !== !1 && (this.previewsContainer = this.options.previewsContainer ? b.getElement(this.options.previewsContainer, "previewsContainer") : this.element), this.options.clickable && (this.clickableElements = this.options.clickable === !0 ? [this.element] : b.getElements(this.options.clickable, "clickable")), this.init()
                }
                var c;
                return l(b, a), b.prototype.events = ["drop", "dragstart", "dragend", "dragenter", "dragover", "dragleave", "addedfile", "removedfile", "thumbnail", "error", "errormultiple", "processing", "processingmultiple", "uploadprogress", "totaluploadprogress", "sending", "sendingmultiple", "success", "successmultiple", "canceled", "canceledmultiple", "complete", "completemultiple", "reset", "maxfilesexceeded", "maxfilesreached"], b.prototype.defaultOptions = {
                    url: null,
                    method: "post",
                    withCredentials: !1,
                    parallelUploads: 2,
                    uploadMultiple: !1,
                    maxFilesize: 256,
                    paramName: "file",
                    createImageThumbnails: !0,
                    maxThumbnailFilesize: 10,
                    thumbnailWidth: 100,
                    thumbnailHeight: 100,
                    maxFiles: null,
                    params: {},
                    clickable: ".fileinput",
                    ignoreHiddenFiles: !0,
                    acceptedFiles: null,
                    acceptedMimeTypes: null,
                    autoProcessQueue: !0,
                    autoQueue: !0,
                    addRemoveLinks: !1,
                    previewsContainer: null,
                    dictDefaultMessage: "Drop files here to upload",
                    dictFallbackMessage: "Your browser does not support drag'n'drop file uploads.",
                    dictFallbackText: "Please use the fallback form below to upload your files like in the olden days.",
                    dictFileTooBig: "File is too big ({{filesize}}MiB). Max filesize: {{maxFilesize}}MiB.",
                    dictInvalidFileType: "You can't upload files of this type.",
                    dictResponseError: "Server responded with {{statusCode}} code.",
                    dictCancelUpload: "Cancel upload",
                    dictCancelUploadConfirmation: "Are you sure you want to cancel this upload?",
                    dictRemoveFile: "Remove file",
                    dictRemoveFileConfirmation: null,
                    dictMaxFilesExceeded: "You can not upload any more files.",
                    accept: function(a, b) {
                        return b()
                    },
                    init: function() {
                        return i
                    },
                    forceFallback: !1,
                    fallback: function() {
                        var a, c, d, e, f, g;
                        for (this.element.className = "" + this.element.className + " dz-browser-not-supported", g = this.element.getElementsByTagName("div"), e = 0, f = g.length; f > e; e++) a = g[e], /(^| )dz-message($| )/.test(a.className) && (c = a, a.className = "dz-message");
                        return c || (c = b.createElement('<div class="dz-message"><span></span></div>'), this.element.appendChild(c)), d = c.getElementsByTagName("span")[0], d && (d.textContent = this.options.dictFallbackMessage), this.element.appendChild(this.getFallbackForm())
                    },
                    resize: function(a) {
                        var b, c, d;
                        return b = {
                            srcX: 0,
                            srcY: 0,
                            srcWidth: a.width,
                            srcHeight: a.height
                        }, c = a.width / a.height, b.optWidth = this.options.thumbnailWidth, b.optHeight = this.options.thumbnailHeight, null == b.optWidth && null == b.optHeight ? (b.optWidth = b.srcWidth, b.optHeight = b.srcHeight) : null == b.optWidth ? b.optWidth = c * b.optHeight : null == b.optHeight && (b.optHeight = 1 / c * b.optWidth), d = b.optWidth / b.optHeight, a.height < b.optHeight || a.width < b.optWidth ? (b.trgHeight = b.srcHeight, b.trgWidth = b.srcWidth) : c > d ? (b.srcHeight = a.height, b.srcWidth = b.srcHeight * d) : (b.srcWidth = a.width, b.srcHeight = b.srcWidth / d), b.srcX = (a.width - b.srcWidth) / 2, b.srcY = (a.height - b.srcHeight) / 2, b
                    },
                    drop: function() {
                        return this.element.classList.remove("dz-drag-hover")
                    },
                    dragstart: i,
                    dragend: function() {
                        return this.element.classList.remove("dz-drag-hover")
                    },
                    dragenter: function() {
                        return this.element.classList.add("dz-drag-hover")
                    },
                    dragover: function() {
                        return this.element.classList.add("dz-drag-hover")
                    },
                    dragleave: function() {
                        return this.element.classList.remove("dz-drag-hover")
                    },
                    paste: i,
                    reset: function() {
                        return this.element.classList.remove("dz-started")
                    },
                    addedfile: function(a) {
                        var c, d, e, f, g, h, i, j, k, l, m, n, o;
                        if (this.element === this.previewsContainer && this.element.classList.add("dz-started"), this.previewsContainer) {
                            for (a.previewElement = b.createElement(this.options.previewTemplate.trim()), a.previewTemplate = a.previewElement, this.previewsContainer.appendChild(a.previewElement), l = a.previewElement.querySelectorAll("[data-dz-name]"), f = 0, i = l.length; i > f; f++) c = l[f], c.textContent = a.name;
                            for (m = a.previewElement.querySelectorAll("[data-dz-size]"), g = 0, j = m.length; j > g; g++) c = m[g], c.innerHTML = this.filesize(a.size);
                            for (this.options.addRemoveLinks && (a._removeLink = b.createElement('<a class="dz-remove" href="javascript:undefined;" data-dz-remove>' + this.options.dictRemoveFile + "</a>"), a.previewElement.appendChild(a._removeLink)), d = function(c) {
                                return function(d) {
                                    return d.preventDefault(), d.stopPropagation(), a.status === b.UPLOADING ? b.confirm(c.options.dictCancelUploadConfirmation, function() {
                                        return c.removeFile(a)
                                    }) : c.options.dictRemoveFileConfirmation ? b.confirm(c.options.dictRemoveFileConfirmation, function() {
                                        return c.removeFile(a)
                                    }) : c.removeFile(a)
                                }
                            }(this), n = a.previewElement.querySelectorAll("[data-dz-remove]"), o = [], h = 0, k = n.length; k > h; h++) e = n[h], o.push(e.addEventListener("click", d));
                            return o
                        }
                    },
                    removedfile: function(a) {
                        var b;
                        return a.previewElement && null != (b = a.previewElement) && b.parentNode.removeChild(a.previewElement), this._updateMaxFilesReachedClass()
                    },
                    thumbnail: function(a, b) {
                        var c, d, e, f, g;
                        if (a.previewElement) {
                            for (a.previewElement.classList.remove("dz-file-preview"), a.previewElement.classList.add("dz-image-preview"), f = a.previewElement.querySelectorAll("[data-dz-thumbnail]"), g = [], d = 0, e = f.length; e > d; d++) c = f[d], c.alt = a.name, g.push(c.src = b);
                            return g
                        }
                    },
                    error: function(a, b) {
                        var c, d, e, f, g;
                        if (a.previewElement) {
                            for (a.previewElement.classList.add("dz-error"), "String" != typeof b && b.error && (b = b.error), f = a.previewElement.querySelectorAll("[data-dz-errormessage]"), g = [], d = 0, e = f.length; e > d; d++) c = f[d], g.push(c.textContent = b);
                            return g
                        }
                    },
                    errormultiple: i,
                    processing: function(a) {
                        return a.previewElement && (a.previewElement.classList.add("dz-processing"), a._removeLink) ? a._removeLink.textContent = this.options.dictCancelUpload : void 0
                    },
                    processingmultiple: i,
                    uploadprogress: function(a, b) {
                        var c, d, e, f, g;
                        if (a.previewElement) {
                            for (f = a.previewElement.querySelectorAll("[data-dz-uploadprogress]"), g = [], d = 0, e = f.length; e > d; d++) c = f[d], g.push(c.style.width = "" + b + "%");
                            return g
                        }
                    },
                    totaluploadprogress: i,
                    sending: i,
                    sendingmultiple: i,
                    success: function(a) {
                        return a.previewElement ? a.previewElement.classList.add("dz-success") : void 0
                    },
                    successmultiple: i,
                    canceled: function(a) {
                        return this.emit("error", a, "Upload canceled.")
                    },
                    canceledmultiple: i,
                    complete: function(a) {
                        return a._removeLink ? a._removeLink.textContent = this.options.dictRemoveFile : void 0
                    },
                    completemultiple: i,
                    maxfilesexceeded: i,
                    maxfilesreached: i,
                    previewTemplate: '<div class="dz-preview dz-file-preview">\n  <div class="dz-details">\n    <div class="dz-filename"><span data-dz-name></span></div>\n    <div class="dz-size" data-dz-size></div>\n    <img data-dz-thumbnail />\n  </div>\n  <div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div>\n  <div class="dz-success-mark"><span>✔</span></div>\n  <div class="dz-error-mark"><span>✘</span></div>\n  <div class="dz-error-message"><span data-dz-errormessage></span></div>\n</div>'
                }, c = function() {
                    var a, b, c, d, e, f, g;
                    for (d = arguments[0], c = 2 <= arguments.length ? m.call(arguments, 1) : [], f = 0, g = c.length; g > f; f++) {
                        b = c[f];
                        for (a in b) e = b[a], d[a] = e
                    }
                    return d
                }, b.prototype.getAcceptedFiles = function() {
                    var a, b, c, d, e;
                    for (d = this.files, e = [], b = 0, c = d.length; c > b; b++) a = d[b], a.accepted && e.push(a);
                    return e
                }, b.prototype.getRejectedFiles = function() {
                    var a, b, c, d, e;
                    for (d = this.files, e = [], b = 0, c = d.length; c > b; b++) a = d[b], a.accepted || e.push(a);
                    return e
                }, b.prototype.getFilesWithStatus = function(a) {
                    var b, c, d, e, f;
                    for (e = this.files, f = [], c = 0, d = e.length; d > c; c++) b = e[c], b.status === a && f.push(b);
                    return f
                }, b.prototype.getQueuedFiles = function() {
                    return this.getFilesWithStatus(b.QUEUED)
                }, b.prototype.getUploadingFiles = function() {
                    return this.getFilesWithStatus(b.UPLOADING)
                }, b.prototype.getActiveFiles = function() {
                    var a, c, d, e, f;
                    for (e = this.files, f = [], c = 0, d = e.length; d > c; c++) a = e[c], (a.status === b.UPLOADING || a.status === b.QUEUED) && f.push(a);
                    return f
                }, b.prototype.init = function() {
                    var a, c, d, e, f, g, h;
                    for ("form" === this.element.tagName && this.element.setAttribute("enctype", "multipart/form-data"), this.element.classList.contains("dropzone") && !this.element.querySelector(".dz-message") && this.element.appendChild(b.createElement('<div class="dz-default dz-message"><span>' + this.options.dictDefaultMessage + "</span></div>")), this.clickableElements.length && (d = function(a) {
                        return function() {
                            return a.hiddenFileInput && document.body.removeChild(a.hiddenFileInput), a.hiddenFileInput = document.createElement("input"), a.hiddenFileInput.setAttribute("type", "file"), (null == a.options.maxFiles || a.options.maxFiles > 1) && a.hiddenFileInput.setAttribute("multiple", "multiple"), a.hiddenFileInput.className = "dz-hidden-input", null != a.options.acceptedFiles && a.hiddenFileInput.setAttribute("accept", a.options.acceptedFiles), a.hiddenFileInput.style.visibility = "hidden", a.hiddenFileInput.style.position = "absolute", a.hiddenFileInput.style.top = "0", a.hiddenFileInput.style.left = "0", a.hiddenFileInput.style.height = "0", a.hiddenFileInput.style.width = "0", document.body.appendChild(a.hiddenFileInput), a.hiddenFileInput.addEventListener("change", function() {
                                var b, c, e, f;
                                if (c = a.hiddenFileInput.files, c.length)
                                    for (e = 0, f = c.length; f > e; e++) b = c[e], a.addFile(b);
                                return d()
                            })
                        }
                    }(this))(), this.URL = null != (g = window.URL) ? g : window.webkitURL, h = this.events, e = 0, f = h.length; f > e; e++) a = h[e], this.on(a, this.options[a]);
                    return this.on("uploadprogress", function(a) {
                        return function() {
                            return a.updateTotalUploadProgress()
                        }
                    }(this)), this.on("removedfile", function(a) {
                        return function() {
                            return a.updateTotalUploadProgress()
                        }
                    }(this)), this.on("canceled", function(a) {
                        return function(b) {
                            return a.emit("complete", b)
                        }
                    }(this)), this.on("complete", function(a) {
                        return function() {
                            return 0 === a.getUploadingFiles().length && 0 === a.getQueuedFiles().length ? setTimeout(function() {
                                return a.emit("queuecomplete")
                            }, 0) : void 0
                        }
                    }(this)), c = function(a) {
                        return a.stopPropagation(), a.preventDefault ? a.preventDefault() : a.returnValue = !1
                    }, this.listeners = [{
                        element: this.element,
                        events: {
                            dragstart: function(a) {
                                return function(b) {
                                    return a.emit("dragstart", b)
                                }
                            }(this),
                            dragenter: function(a) {
                                return function(b) {
                                    return c(b), a.emit("dragenter", b)
                                }
                            }(this),
                            dragover: function(a) {
                                return function(b) {
                                    var d;
                                    try {
                                        d = b.dataTransfer.effectAllowed
                                    } catch (e) {}
                                    return b.dataTransfer.dropEffect = "move" === d || "linkMove" === d ? "move" : "copy", c(b), a.emit("dragover", b)
                                }
                            }(this),
                            dragleave: function(a) {
                                return function(b) {
                                    return a.emit("dragleave", b)
                                }
                            }(this),
                            drop: function(a) {
                                return function(b) {
                                    return c(b), a.drop(b)
                                }
                            }(this),
                            dragend: function(a) {
                                return function(b) {
                                    return a.emit("dragend", b)
                                }
                            }(this)
                        }
                    }], this.clickableElements.forEach(function(a) {
                        return function(c) {
                            return a.listeners.push({
                                element: c,
                                events: {
                                    click: function(d) {
                                        return c !== a.element || d.target === a.element || b.elementInside(d.target, a.element.querySelector(".dz-message")) ? a.hiddenFileInput.click() : void 0
                                    }
                                }
                            })
                        }
                    }(this)), this.enable(), this.options.init.call(this)
                }, b.prototype.destroy = function() {
                    var a;
                    return this.disable(), this.removeAllFiles(!0), (null != (a = this.hiddenFileInput) ? a.parentNode : void 0) && (this.hiddenFileInput.parentNode.removeChild(this.hiddenFileInput), this.hiddenFileInput = null), delete this.element.dropzone, b.instances.splice(b.instances.indexOf(this), 1)
                }, b.prototype.updateTotalUploadProgress = function() {
                    var a, b, c, d, e, f, g, h;
                    if (d = 0, c = 0, a = this.getActiveFiles(), a.length) {
                        for (h = this.getActiveFiles(), f = 0, g = h.length; g > f; f++) b = h[f], d += b.upload.bytesSent, c += b.upload.total;
                        e = 100 * d / c
                    } else e = 100;
                    return this.emit("totaluploadprogress", e, c, d)
                }, b.prototype._getParamName = function(a) {
                    return "function" == typeof this.options.paramName ? this.options.paramName(a) : "" + this.options.paramName + (this.options.uploadMultiple ? "[" + a + "]" : "")
                }, b.prototype.getFallbackForm = function() {
                    var a, c, d, e;
                    return (a = this.getExistingFallback()) ? a : (d = '<div class="dz-fallback">', this.options.dictFallbackText && (d += "<p>" + this.options.dictFallbackText + "</p>"), d += '<input type="file" name="' + this._getParamName(0) + '" ' + (this.options.uploadMultiple ? 'multiple="multiple"' : void 0) + ' /><input type="submit" value="Upload!"></div>', c = b.createElement(d), "FORM" !== this.element.tagName ? (e = b.createElement('<form action="' + this.options.url + '" enctype="multipart/form-data" method="' + this.options.method + '"></form>'), e.appendChild(c)) : (this.element.setAttribute("enctype", "multipart/form-data"), this.element.setAttribute("method", this.options.method)), null != e ? e : c)
                }, b.prototype.getExistingFallback = function() {
                    var a, b, c, d, e, f;
                    for (b = function(a) {
                        var b, c, d;
                        for (c = 0, d = a.length; d > c; c++)
                            if (b = a[c], /(^| )fallback($| )/.test(b.className)) return b
                    }, f = ["div", "form"], d = 0, e = f.length; e > d; d++)
                        if (c = f[d], a = b(this.element.getElementsByTagName(c))) return a
                }, b.prototype.setupEventListeners = function() {
                    var a, b, c, d, e, f, g;
                    for (f = this.listeners, g = [], d = 0, e = f.length; e > d; d++) a = f[d], g.push(function() {
                        var d, e;
                        d = a.events, e = [];
                        for (b in d) c = d[b], e.push(a.element.addEventListener(b, c, !1));
                        return e
                    }());
                    return g
                }, b.prototype.removeEventListeners = function() {
                    var a, b, c, d, e, f, g;
                    for (f = this.listeners, g = [], d = 0, e = f.length; e > d; d++) a = f[d], g.push(function() {
                        var d, e;
                        d = a.events, e = [];
                        for (b in d) c = d[b], e.push(a.element.removeEventListener(b, c, !1));
                        return e
                    }());
                    return g
                }, b.prototype.disable = function() {
                    var a, b, c, d, e;
                    for (this.clickableElements.forEach(function(a) {
                        return a.classList.remove("dz-clickable")
                    }), this.removeEventListeners(), d = this.files, e = [], b = 0, c = d.length; c > b; b++) a = d[b], e.push(this.cancelUpload(a));
                    return e
                }, b.prototype.enable = function() {
                    return this.clickableElements.forEach(function(a) {
                        return a.classList.add("dz-clickable")
                    }), this.setupEventListeners()
                }, b.prototype.filesize = function(a) {
                    var b;
                    return a >= 109951162777.6 ? (a /= 109951162777.6, b = "TiB") : a >= 107374182.4 ? (a /= 107374182.4, b = "GiB") : a >= 104857.6 ? (a /= 104857.6, b = "MiB") : a >= 102.4 ? (a /= 102.4, b = "KiB") : (a = 10 * a, b = "b"), "<strong>" + Math.round(a) / 10 + "</strong> " + b
                }, b.prototype._updateMaxFilesReachedClass = function() {
                    return null != this.options.maxFiles && this.getAcceptedFiles().length >= this.options.maxFiles ? (this.getAcceptedFiles().length === this.options.maxFiles && this.emit("maxfilesreached", this.files), this.element.classList.add("dz-max-files-reached")) : this.element.classList.remove("dz-max-files-reached")
                }, b.prototype.drop = function(a) {
                    var b, c;
                    a.dataTransfer && (this.emit("drop", a), b = a.dataTransfer.files, b.length && (c = a.dataTransfer.items, c && c.length && null != c[0].webkitGetAsEntry ? this._addFilesFromItems(c) : this.handleFiles(b)))
                }, b.prototype.paste = function(a) {
                    var b, c;
                    if (null != (null != a && null != (c = a.clipboardData) ? c.items : void 0)) return this.emit("paste", a), b = a.clipboardData.items, b.length ? this._addFilesFromItems(b) : void 0
                }, b.prototype.handleFiles = function(a) {
                    var b, c, d, e;
                    for (e = [], c = 0, d = a.length; d > c; c++) b = a[c], e.push(this.addFile(b));
                    return e
                }, b.prototype._addFilesFromItems = function(a) {
                    var b, c, d, e, f;
                    for (f = [], d = 0, e = a.length; e > d; d++) c = a[d], f.push(null != c.webkitGetAsEntry && (b = c.webkitGetAsEntry()) ? b.isFile ? this.addFile(c.getAsFile()) : b.isDirectory ? this._addFilesFromDirectory(b, b.name) : void 0 : null != c.getAsFile ? null == c.kind || "file" === c.kind ? this.addFile(c.getAsFile()) : void 0 : void 0);
                    return f
                }, b.prototype._addFilesFromDirectory = function(a, b) {
                    var c, d;
                    return c = a.createReader(), d = function(a) {
                        return function(c) {
                            var d, e, f;
                            for (e = 0, f = c.length; f > e; e++) d = c[e], d.isFile ? d.file(function(c) {
                                return a.options.ignoreHiddenFiles && "." === c.name.substring(0, 1) ? void 0 : (c.fullPath = "" + b + "/" + c.name, a.addFile(c))
                            }) : d.isDirectory && a._addFilesFromDirectory(d, "" + b + "/" + d.name)
                        }
                    }(this), c.readEntries(d, function(a) {
                        return "undefined" != typeof console && null !== console && "function" == typeof console.log ? console.log(a) : void 0
                    })
                }, b.prototype.accept = function(a, c) {
                    return a.size > 1024 * this.options.maxFilesize * 1024 ? c(this.options.dictFileTooBig.replace("{{filesize}}", Math.round(a.size / 1024 / 10.24) / 100).replace("{{maxFilesize}}", this.options.maxFilesize)) : b.isValidFile(a, this.options.acceptedFiles) ? null != this.options.maxFiles && this.getAcceptedFiles().length >= this.options.maxFiles ? (c(this.options.dictMaxFilesExceeded.replace("{{maxFiles}}", this.options.maxFiles)), this.emit("maxfilesexceeded", a)) : this.options.accept.call(this, a, c) : c(this.options.dictInvalidFileType)
                }, b.prototype.addFile = function(a) {
                    return a.upload = {
                        progress: 0,
                        total: a.size,
                        bytesSent: 0
                    }, this.files.push(a), a.status = b.ADDED, this.emit("addedfile", a), this._enqueueThumbnail(a), this.accept(a, function(b) {
                        return function(c) {
                            return c ? (a.accepted = !1, b._errorProcessing([a], c)) : (a.accepted = !0, b.options.autoQueue && b.enqueueFile(a)), b._updateMaxFilesReachedClass()
                        }
                    }(this))
                }, b.prototype.enqueueFiles = function(a) {
                    var b, c, d;
                    for (c = 0, d = a.length; d > c; c++) b = a[c], this.enqueueFile(b);
                    return null
                }, b.prototype.enqueueFile = function(a) {
                    if (a.status !== b.ADDED || a.accepted !== !0) throw new Error("This file can't be queued because it has already been processed or was rejected.");
                    return a.status = b.QUEUED, this.options.autoProcessQueue ? setTimeout(function(a) {
                        return function() {
                            return a.processQueue()
                        }
                    }(this), 0) : void 0
                }, b.prototype._thumbnailQueue = [], b.prototype._processingThumbnail = !1, b.prototype._enqueueThumbnail = function(a) {
                    return this.options.createImageThumbnails && a.type.match(/image.*/) && a.size <= 1024 * this.options.maxThumbnailFilesize * 1024 ? (this._thumbnailQueue.push(a), setTimeout(function(a) {
                        return function() {
                            return a._processThumbnailQueue()
                        }
                    }(this), 0)) : void 0
                }, b.prototype._processThumbnailQueue = function() {
                    return this._processingThumbnail || 0 === this._thumbnailQueue.length ? void 0 : (this._processingThumbnail = !0, this.createThumbnail(this._thumbnailQueue.shift(), function(a) {
                        return function() {
                            return a._processingThumbnail = !1, a._processThumbnailQueue()
                        }
                    }(this)))
                }, b.prototype.removeFile = function(a) {
                    return a.status === b.UPLOADING && this.cancelUpload(a), this.files = j(this.files, a), this.emit("removedfile", a), 0 === this.files.length ? this.emit("reset") : void 0
                }, b.prototype.removeAllFiles = function(a) {
                    var c, d, e, f;
                    for (null == a && (a = !1), f = this.files.slice(), d = 0, e = f.length; e > d; d++) c = f[d], (c.status !== b.UPLOADING || a) && this.removeFile(c);
                    return null
                }, b.prototype.createThumbnail = function(a, b) {
                    var c;
                    return c = new FileReader, c.onload = function(d) {
                        return function() {
                            var e;
                            return e = document.createElement("img"), e.onload = function() {
                                var c, f, g, i, j, k, l, m;
                                return a.width = e.width, a.height = e.height, g = d.options.resize.call(d, a), null == g.trgWidth && (g.trgWidth = g.optWidth), null == g.trgHeight && (g.trgHeight = g.optHeight), c = document.createElement("canvas"), f = c.getContext("2d"), c.width = g.trgWidth, c.height = g.trgHeight, h(f, e, null != (j = g.srcX) ? j : 0, null != (k = g.srcY) ? k : 0, g.srcWidth, g.srcHeight, null != (l = g.trgX) ? l : 0, null != (m = g.trgY) ? m : 0, g.trgWidth, g.trgHeight), i = c.toDataURL("image/png"), d.emit("thumbnail", a, i), null != b ? b() : void 0
                            }, e.src = c.result
                        }
                    }(this), c.readAsDataURL(a)
                }, b.prototype.processQueue = function() {
                    var a, b, c, d;
                    if (b = this.options.parallelUploads, c = this.getUploadingFiles().length, a = c, !(c >= b) && (d = this.getQueuedFiles(), d.length > 0)) {
                        if (this.options.uploadMultiple) return this.processFiles(d.slice(0, b - c));
                        for (; b > a;) {
                            if (!d.length) return;
                            this.processFile(d.shift()), a++
                        }
                    }
                }, b.prototype.processFile = function(a) {
                    return this.processFiles([a])
                }, b.prototype.processFiles = function(a) {
                    var c, d, e;
                    for (d = 0, e = a.length; e > d; d++) c = a[d], c.processing = !0, c.status = b.UPLOADING, this.emit("processing", c);
                    return this.options.uploadMultiple && this.emit("processingmultiple", a), this.uploadFiles(a)
                }, b.prototype._getFilesWithXhr = function(a) {
                    var b, c;
                    return c = function() {
                        var c, d, e, f;
                        for (e = this.files, f = [], c = 0, d = e.length; d > c; c++) b = e[c], b.xhr === a && f.push(b);
                        return f
                    }.call(this)
                }, b.prototype.cancelUpload = function(a) {
                    var c, d, e, f, g, h, i;
                    if (a.status === b.UPLOADING) {
                        for (d = this._getFilesWithXhr(a.xhr), e = 0, g = d.length; g > e; e++) c = d[e], c.status = b.CANCELED;
                        for (a.xhr.abort(), f = 0, h = d.length; h > f; f++) c = d[f], this.emit("canceled", c);
                        this.options.uploadMultiple && this.emit("canceledmultiple", d)
                    } else((i = a.status) === b.ADDED || i === b.QUEUED) && (a.status = b.CANCELED, this.emit("canceled", a), this.options.uploadMultiple && this.emit("canceledmultiple", [a]));
                    return this.options.autoProcessQueue ? this.processQueue() : void 0
                }, b.prototype.uploadFile = function(a) {
                    return this.uploadFiles([a])
                }, b.prototype.uploadFiles = function(a) {
                    var d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H, I;
                    for (t = new XMLHttpRequest, u = 0, y = a.length; y > u; u++) d = a[u], d.xhr = t;
                    t.open(this.options.method, this.options.url, !0), t.withCredentials = !!this.options.withCredentials, q = null, f = function(b) {
                        return function() {
                            var c, e, f;
                            for (f = [], c = 0, e = a.length; e > c; c++) d = a[c], f.push(b._errorProcessing(a, q || b.options.dictResponseError.replace("{{statusCode}}", t.status), t));
                            return f
                        }
                    }(this), r = function(b) {
                        return function(c) {
                            var e, f, g, h, i, j, k, l, m;
                            if (null != c)
                                for (f = 100 * c.loaded / c.total, g = 0, j = a.length; j > g; g++) d = a[g], d.upload = {
                                    progress: f,
                                    total: c.total,
                                    bytesSent: c.loaded
                                };
                            else {
                                for (e = !0, f = 100, h = 0, k = a.length; k > h; h++) d = a[h], (100 !== d.upload.progress || d.upload.bytesSent !== d.upload.total) && (e = !1), d.upload.progress = f, d.upload.bytesSent = d.upload.total;
                                if (e) return
                            }
                            for (m = [], i = 0, l = a.length; l > i; i++) d = a[i], m.push(b.emit("uploadprogress", d, f, d.upload.bytesSent));
                            return m
                        }
                    }(this), t.onload = function(c) {
                        return function(d) {
                            var e;
                            if (a[0].status !== b.CANCELED && 4 === t.readyState) {
                                if (q = t.responseText, t.getResponseHeader("content-type") && ~t.getResponseHeader("content-type").indexOf("application/json")) try {
                                    q = JSON.parse(q)
                                } catch (g) {
                                    d = g, q = "Invalid JSON response from server."
                                }
                                return r(), 200 <= (e = t.status) && 300 > e ? c._finished(a, q, d) : f()
                            }
                        }
                    }(this), t.onerror = function() {
                        return function() {
                            return a[0].status !== b.CANCELED ? f() : void 0
                        }
                    }(this), p = null != (D = t.upload) ? D : t, p.onprogress = r, i = {
                        Accept: "application/json",
                        "Cache-Control": "no-cache",
                        "X-Requested-With": "XMLHttpRequest"
                    }, this.options.headers && c(i, this.options.headers);
                    for (g in i) h = i[g], t.setRequestHeader(g, h);
                    if (e = new FormData, this.options.params) {
                        E = this.options.params;
                        for (n in E) s = E[n], e.append(n, s)
                    }
                    for (v = 0, z = a.length; z > v; v++) d = a[v], this.emit("sending", d, t, e);
                    if (this.options.uploadMultiple && this.emit("sendingmultiple", a, t, e), "FORM" === this.element.tagName)
                        for (F = this.element.querySelectorAll("input, textarea, select, button"), w = 0, A = F.length; A > w; w++)
                            if (k = F[w], l = k.getAttribute("name"), m = k.getAttribute("type"), "SELECT" === k.tagName && k.hasAttribute("multiple"))
                                for (G = k.options, x = 0, B = G.length; B > x; x++) o = G[x], o.selected && e.append(l, o.value);
                            else(!m || "checkbox" !== (H = m.toLowerCase()) && "radio" !== H || k.checked) && e.append(l, k.value);
                    for (j = C = 0, I = a.length - 1; I >= 0 ? I >= C : C >= I; j = I >= 0 ? ++C : --C) e.append(this._getParamName(j), a[j], a[j].name);
                    return t.send(e)
                }, b.prototype._finished = function(a, c, d) {
                    var e, f, g;
                    for (f = 0, g = a.length; g > f; f++) e = a[f], e.status = b.SUCCESS, this.emit("success", e, c, d), this.emit("complete", e);
                    return this.options.uploadMultiple && (this.emit("successmultiple", a, c, d), this.emit("completemultiple", a)), this.options.autoProcessQueue ? this.processQueue() : void 0
                }, b.prototype._errorProcessing = function(a, c, d) {
                    var e, f, g;
                    for (f = 0, g = a.length; g > f; f++) e = a[f], e.status = b.ERROR, this.emit("error", e, c, d), this.emit("complete", e);
                    return this.options.uploadMultiple && (this.emit("errormultiple", a, c, d), this.emit("completemultiple", a)), this.options.autoProcessQueue ? this.processQueue() : void 0
                }, b
            }(d), b.version = "3.10.2", b.options = {}, b.optionsForElement = function(a) {
                return a.getAttribute("id") ? b.options[e(a.getAttribute("id"))] : void 0
            }, b.instances = [], b.forElement = function(a) {
                if ("string" == typeof a && (a = document.querySelector(a)), null == (null != a ? a.dropzone : void 0)) throw new Error("No Dropzone found for given element. This is probably because you're trying to access it before Dropzone had the time to initialize. Use the `init` option to setup any additional observers on your Dropzone.");
                return a.dropzone
            }, b.autoDiscover = !0, b.discover = function() {
                var a, c, d, e, f, g;
                for (document.querySelectorAll ? d = document.querySelectorAll(".dropzone") : (d = [], a = function(a) {
                    var b, c, e, f;
                    for (f = [], c = 0, e = a.length; e > c; c++) b = a[c], f.push(/(^| )dropzone($| )/.test(b.className) ? d.push(b) : void 0);
                    return f
                }, a(document.getElementsByTagName("div")), a(document.getElementsByTagName("form"))), g = [], e = 0, f = d.length; f > e; e++) c = d[e], g.push(b.optionsForElement(c) !== !1 ? new b(c) : void 0);
                return g
            }, b.blacklistedBrowsers = [/opera.*Macintosh.*version\/12/i], b.isBrowserSupported = function() {
                var a, c, d, e, f;
                if (a = !0, window.File && window.FileReader && window.FileList && window.Blob && window.FormData && document.querySelector)
                    if ("classList" in document.createElement("a"))
                        for (f = b.blacklistedBrowsers, d = 0, e = f.length; e > d; d++) c = f[d], c.test(navigator.userAgent) && (a = !1);
                    else a = !1;
                else a = !1;
                return a
            }, j = function(a, b) {
                var c, d, e, f;
                for (f = [], d = 0, e = a.length; e > d; d++) c = a[d], c !== b && f.push(c);
                return f
            }, e = function(a) {
                return a.replace(/[\-_](\w)/g, function(a) {
                    return a.charAt(1).toUpperCase()
                })
            }, b.createElement = function(a) {
                var b;
                return b = document.createElement("div"), b.innerHTML = a, b.childNodes[0]
            }, b.elementInside = function(a, b) {
                if (a === b) return !0;
                for (; a = a.parentNode;)
                    if (a === b) return !0;
                return !1
            }, b.getElement = function(a, b) {
                var c;
                if ("string" == typeof a ? c = document.querySelector(a) : null != a.nodeType && (c = a), null == c) throw new Error("Invalid `" + b + "` option provided. Please provide a CSS selector or a plain HTML element.");
                return c
            }, b.getElements = function(a, b) {
                var c, d, e, f, g, h, i, j;
                if (a instanceof Array) {
                    e = [];
                    try {
                        for (f = 0, h = a.length; h > f; f++) d = a[f], e.push(this.getElement(d, b))
                    } catch (k) {
                        c = k, e = null
                    }
                } else if ("string" == typeof a)
                    for (e = [], j = document.querySelectorAll(a), g = 0, i = j.length; i > g; g++) d = j[g], e.push(d);
                else null != a.nodeType && (e = [a]); if (null == e || !e.length) throw new Error("Invalid `" + b + "` option provided. Please provide a CSS selector, a plain HTML element or a list of those.");
                return e
            }, b.confirm = function(a, b, c) {
                return window.confirm(a) ? b() : null != c ? c() : void 0
            }, b.isValidFile = function(a, b) {
                var c, d, e, f, g;
                if (!b) return !0;
                for (b = b.split(","), d = a.type, c = d.replace(/\/.*$/, ""), f = 0, g = b.length; g > f; f++)
                    if (e = b[f], e = e.trim(), "." === e.charAt(0)) {
                        if (-1 !== a.name.toLowerCase().indexOf(e.toLowerCase(), a.name.length - e.length)) return !0
                    } else if (/\/\*$/.test(e)) {
                    if (c === e.replace(/\/.*$/, "")) return !0
                } else if (d === e) return !0;
                return !1
            }, "undefined" != typeof jQuery && null !== jQuery && (jQuery.fn.dropzone = function(a) {
                return this.each(function() {
                    return new b(this, a)
                })
            }), "undefined" != typeof c && null !== c ? c.exports = b : window.Dropzone = b, b.ADDED = "added", b.QUEUED = "queued", b.ACCEPTED = b.QUEUED, b.UPLOADING = "uploading", b.PROCESSING = b.UPLOADING, b.CANCELED = "canceled", b.ERROR = "error", b.SUCCESS = "success", g = function(a) {
                var b, c, d, e, f, g, h, i, j, k;
                for (h = a.naturalWidth, g = a.naturalHeight, c = document.createElement("canvas"), c.width = 1, c.height = g, d = c.getContext("2d"), d.drawImage(a, 0, 0), e = d.getImageData(0, 0, 1, g).data, k = 0, f = g, i = g; i > k;) b = e[4 * (i - 1) + 3], 0 === b ? f = i : k = i, i = f + k >> 1;
                return j = i / g, 0 === j ? 1 : j
            }, h = function(a, b, c, d, e, f, h, i, j, k) {
                var l;
                return l = g(b), a.drawImage(b, c, d, e, f, h, i, j, k / l)
            }, f = function(a, b) {
                var c, d, e, f, g, h, i, j, k;
                if (e = !1, k = !0, d = a.document, j = d.documentElement, c = d.addEventListener ? "addEventListener" : "attachEvent", i = d.addEventListener ? "removeEventListener" : "detachEvent", h = d.addEventListener ? "" : "on", f = function(c) {
                    return "readystatechange" !== c.type || "complete" === d.readyState ? (("load" === c.type ? a : d)[i](h + c.type, f, !1), !e && (e = !0) ? b.call(a, c.type || c) : void 0) : void 0
                }, g = function() {
                    var a;
                    try {
                        j.doScroll("left")
                    } catch (b) {
                        return a = b, void setTimeout(g, 50)
                    }
                    return f("poll")
                }, "complete" !== d.readyState) {
                    if (d.createEventObject && j.doScroll) {
                        try {
                            k = !a.frameElement
                        } catch (l) {}
                        k && g()
                    }
                    return d[c](h + "DOMContentLoaded", f, !1), d[c](h + "readystatechange", f, !1), a[c](h + "load", f, !1)
                }
            }, b._autoDiscoverFunction = function() {
                return b.autoDiscover ? b.discover() : void 0
            }, f(window, b._autoDiscoverFunction)
        }).call(this)
    }), "object" == typeof exports ? module.exports = a("dropzone") : "function" == typeof define && define.amd ? define([], function() {
        return a("dropzone")
    }) : this.Dropzone = a("dropzone")
}();
