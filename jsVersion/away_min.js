var away;
(function (away) {
    (function (events) {
        var Event = (function () {
            function Event(type) {
                this.type = undefined;
                this.target = undefined;
                this.type = type;
            }
            Event.prototype.clone = function () {
                return new Event(this.type);
            };
            Event.COMPLETE = 'Event_Complete';
            Event.OPEN = 'Event_Open';
            return Event;
        })();
        events.Event = Event;
    })(away.events || (away.events = {}));
    var events = away.events;
})(away || (away = {}));
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var away;
(function (away) {
    (function (events) {
        var AwayEvent = (function (_super) {
            __extends(AwayEvent, _super);
            function AwayEvent(type, message) {
                if (typeof message === "undefined") { message = ""; }
                _super.call(this, type);
                this.message = message;
            }
            AwayEvent.CONTEXT3D_CREATE = "context3DCreate";
            AwayEvent.ERROR = "context3DERROR";
            return AwayEvent;
        })(away.events.Event);
        events.AwayEvent = AwayEvent;
    })(away.events || (away.events = {}));
    var events = away.events;
})(away || (away = {}));
var away;
(function (away) {
    (function (events) {
        var EventDispatcher = (function () {
            function EventDispatcher() {
                this.listeners = new Array();
            }
            EventDispatcher.prototype.addEventListener = function (type, listener, target) {
                if (this.listeners[type] === undefined) {
                    this.listeners[type] = new Array();
                }

                if (this.getEventListenerIndex(type, listener, target) === -1) {
                    var d = new EventData();
                    d.listener = listener;
                    d.type = type;
                    d.target = target;

                    this.listeners[type].push(d);
                }
            };

            EventDispatcher.prototype.removeEventListener = function (type, listener, target) {
                var index = this.getEventListenerIndex(type, listener, target);

                if (index !== -1) {
                    this.listeners[type].splice(index, 1);
                }
            };

            EventDispatcher.prototype.dispatchEvent = function (event) {
                var listenerArray = this.listeners[event.type];

                if (listenerArray !== undefined) {
                    this.lFncLength = listenerArray.length;
                    event.target = this;

                    var eventData;

                    for (var i = 0, l = this.lFncLength; i < l; i++) {
                        eventData = listenerArray[i];
                        eventData.listener.call(eventData.target, event);
                    }
                }
            };

            EventDispatcher.prototype.getEventListenerIndex = function (type, listener, target) {
                if (this.listeners[type] !== undefined) {
                    var a = this.listeners[type];
                    var l = a.length;
                    var d;

                    for (var c = 0; c < l; c++) {
                        d = a[c];

                        if (target == d.target && listener == d.listener) {
                            return c;
                        }
                    }
                }

                return -1;
            };

            EventDispatcher.prototype.hasEventListener = function (type, listener, target) {
                return (this.getEventListenerIndex(type, listener, target) !== -1);
            };
            return EventDispatcher;
        })();
        events.EventDispatcher = EventDispatcher;

        var EventData = (function () {
            function EventData() {
            }
            return EventData;
        })();
    })(away.events || (away.events = {}));
    var events = away.events;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3DClearMask = (function () {
            function Context3DClearMask() {
            }
            Context3DClearMask.COLOR = 8 << 11;
            Context3DClearMask.DEPTH = 8 << 5;
            Context3DClearMask.STENCIL = 8 << 7;
            Context3DClearMask.ALL = Context3DClearMask.COLOR | Context3DClearMask.DEPTH | Context3DClearMask.STENCIL;
            return Context3DClearMask;
        })();
        display3D.Context3DClearMask = Context3DClearMask;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var VertexBuffer3D = (function () {
            function VertexBuffer3D(numVertices, data32PerVertex) {
                this._buffer = GL.createBuffer();
                this._numVertices = numVertices;
                this._data32PerVertex = data32PerVertex;
            }
            VertexBuffer3D.prototype.upload = function (vertices, startVertex, numVertices) {
                GL.bindBuffer(GL.ARRAY_BUFFER, this._buffer);
                console.log("** WARNING upload not fully implemented, startVertex & numVertices not considered.");

                GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vertices), GL.STATIC_DRAW);
            };

            Object.defineProperty(VertexBuffer3D.prototype, "numVertices", {
                get: function () {
                    return this._numVertices;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(VertexBuffer3D.prototype, "data32PerVertex", {
                get: function () {
                    return this._data32PerVertex;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(VertexBuffer3D.prototype, "glBuffer", {
                get: function () {
                    return this._buffer;
                },
                enumerable: true,
                configurable: true
            });

            VertexBuffer3D.prototype.dispose = function () {
                GL.deleteBuffer(this._buffer);
            };
            return VertexBuffer3D;
        })();
        display3D.VertexBuffer3D = VertexBuffer3D;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var IndexBuffer3D = (function () {
            function IndexBuffer3D(numIndices) {
                this._buffer = GL.createBuffer();
                this._numIndices = numIndices;
            }
            IndexBuffer3D.prototype.upload = function (data, startOffset, count) {
                GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this._buffer);

                GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16Array(data), GL.STATIC_DRAW);
            };

            IndexBuffer3D.prototype.dispose = function () {
                GL.deleteBuffer(this._buffer);
            };

            Object.defineProperty(IndexBuffer3D.prototype, "numIndices", {
                get: function () {
                    return this._numIndices;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IndexBuffer3D.prototype, "glBuffer", {
                get: function () {
                    return this._buffer;
                },
                enumerable: true,
                configurable: true
            });
            return IndexBuffer3D;
        })();
        display3D.IndexBuffer3D = IndexBuffer3D;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Program3D = (function () {
            function Program3D() {
                this._program = GL.createProgram();
            }
            Program3D.prototype.upload = function (vertexProgram, fragmentProgram) {
                this._vertexShader = GL.createShader(GL.VERTEX_SHADER);
                this._fragmentShader = GL.createShader(GL.FRAGMENT_SHADER);

                GL.shaderSource(this._vertexShader, vertexProgram);
                GL.compileShader(this._vertexShader);

                if (!GL.getShaderParameter(this._vertexShader, GL.COMPILE_STATUS)) {
                    alert(GL.getShaderInfoLog(this._vertexShader));
                    return null;
                }

                GL.shaderSource(this._fragmentShader, fragmentProgram);
                GL.compileShader(this._fragmentShader);

                if (!GL.getShaderParameter(this._fragmentShader, GL.COMPILE_STATUS)) {
                    alert(GL.getShaderInfoLog(this._fragmentShader));
                    return null;
                }

                GL.attachShader(this._program, this._vertexShader);
                GL.attachShader(this._program, this._fragmentShader);
                GL.linkProgram(this._program);

                if (!GL.getProgramParameter(this._program, GL.LINK_STATUS)) {
                    alert("Could not link the program.");
                }
            };

            Program3D.prototype.dispose = function () {
                GL.deleteProgram(this._program);
            };

            Program3D.prototype.focusProgram = function () {
                GL.useProgram(this._program);
            };

            Object.defineProperty(Program3D.prototype, "glProgram", {
                get: function () {
                    return this._program;
                },
                enumerable: true,
                configurable: true
            });
            return Program3D;
        })();
        display3D.Program3D = Program3D;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (geom) {
        var Vector3D = (function () {
            function Vector3D(x, y, z, w) {
                if (typeof x === "undefined") { x = 0; }
                if (typeof y === "undefined") { y = 0; }
                if (typeof z === "undefined") { z = 0; }
                if (typeof w === "undefined") { w = 0; }
                this.x = x;
                this.y = y;
                this.z = z;
                this.w = w;
            }
            Object.defineProperty(Vector3D.prototype, "length", {
                get: function () {
                    return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Vector3D.prototype, "lengthSquared", {
                get: function () {
                    return (this.x * this.x + this.y * this.y + this.z + this.z);
                },
                enumerable: true,
                configurable: true
            });

            Vector3D.prototype.add = function (a) {
                return new Vector3D(this.x + a.x, this.y + a.y, this.z + a.z, this.w + a.w);
            };

            Vector3D.angleBetween = function (a, b) {
                return Math.acos(a.dotProduct(b) / (a.length * b.length));
            };

            Vector3D.prototype.clone = function () {
                return new Vector3D(this.x, this.y, this.z, this.w);
            };

            Vector3D.prototype.copyFrom = function (src) {
                return new Vector3D(src.x, src.y, src.z, src.w);
            };

            Vector3D.prototype.crossProduct = function (a) {
                return new Vector3D(this.y * a.z - this.z * a.y, this.z * a.x - this.x * a.z, this.x * a.y - this.y * a.x);
            };

            Vector3D.prototype.decrementBy = function (a) {
                this.x -= a.x;
                this.y -= a.y;
                this.z -= a.z;
            };

            Vector3D.distance = function (pt1, pt2) {
                var x = (pt1.x - pt2.x);
                var y = (pt1.y - pt2.y);
                var z = (pt1.z - pt2.z);
                return Math.sqrt(x * x + y * y + z * z);
            };

            Vector3D.prototype.dotProduct = function (a) {
                return this.x * a.x + this.y * a.y + this.z * a.z;
            };

            Vector3D.prototype.equals = function (cmp, allFour) {
                if (typeof allFour === "undefined") { allFour = false; }
                return (this.x == cmp.x && this.y == cmp.y && this.z == cmp.z && (!allFour || this.w == cmp.w));
            };

            Vector3D.prototype.incrementBy = function (a) {
                this.x += a.x;
                this.y += a.y;
                this.z += a.z;
            };

            Vector3D.prototype.nearEquals = function (cmp, epsilon, allFour) {
                if (typeof allFour === "undefined") { allFour = true; }
                return ((Math.abs(this.x - cmp.x) < epsilon) && (Math.abs(this.y - cmp.y) < epsilon) && (Math.abs(this.z - cmp.z) < epsilon) && (!allFour || Math.abs(this.w - cmp.w) < epsilon));
            };

            Vector3D.prototype.negate = function () {
                this.x = -this.x;
                this.y = -this.y;
                this.z = -this.z;
            };

            Vector3D.prototype.normalize = function () {
                var invLength = 1 / this.length;
                if (invLength != 0) {
                    this.x *= invLength;
                    this.y *= invLength;
                    this.z *= invLength;
                    return;
                }
                throw "Cannot divide by zero.";
            };

            Vector3D.prototype.project = function () {
                this.x /= this.w;
                this.y /= this.w;
                this.z /= this.w;
            };

            Vector3D.prototype.scaleBy = function (s) {
                this.x *= s;
                this.y *= s;
                this.z *= s;
            };

            Vector3D.prototype.setTo = function (xa, ya, za) {
                this.x = xa;
                this.y = ya;
                this.z = za;
            };

            Vector3D.prototype.subtract = function (a) {
                return new Vector3D(this.x - a.x, this.y - a.y, this.z - a.z);
            };

            Vector3D.prototype.toString = function () {
                return "[Vector3D] (x:" + this.x + " ,y:" + this.y + ", z" + this.z + ", w:" + this.w + ")";
            };
            return Vector3D;
        })();
        geom.Vector3D = Vector3D;
    })(away.geom || (away.geom = {}));
    var geom = away.geom;
})(away || (away = {}));
var away;
(function (away) {
    (function (errors) {
        var Error = (function () {
            function Error(message, id, _name) {
                if (typeof message === "undefined") { message = ''; }
                if (typeof id === "undefined") { id = 0; }
                if (typeof _name === "undefined") { _name = ''; }
                this._errorID = 0;
                this._messsage = '';
                this._name = '';
                this._messsage = message;
                this._name = name;
                this._errorID = id;
            }
            Object.defineProperty(Error.prototype, "message", {
                get: function () {
                    return this._messsage;
                },
                set: function (value) {
                    this._messsage = value;
                },
                enumerable: true,
                configurable: true
            });


            Object.defineProperty(Error.prototype, "name", {
                get: function () {
                    return this._name;
                },
                set: function (value) {
                    this._name = value;
                },
                enumerable: true,
                configurable: true
            });


            Object.defineProperty(Error.prototype, "errorID", {
                get: function () {
                    return this._errorID;
                },
                enumerable: true,
                configurable: true
            });
            return Error;
        })();
        errors.Error = Error;
    })(away.errors || (away.errors = {}));
    var errors = away.errors;
})(away || (away = {}));
var away;
(function (away) {
    (function (errors) {
        var ArgumentError = (function (_super) {
            __extends(ArgumentError, _super);
            function ArgumentError(message, id) {
                if (typeof message === "undefined") { message = null; }
                if (typeof id === "undefined") { id = 0; }
                _super.call(this, message || "ArgumentError", id);
            }
            return ArgumentError;
        })(errors.Error);
        errors.ArgumentError = ArgumentError;
    })(away.errors || (away.errors = {}));
    var errors = away.errors;
})(away || (away = {}));
var away;
(function (away) {
    (function (geom) {
        var Matrix3D = (function () {
            function Matrix3D(v) {
                if (typeof v === "undefined") { v = null; }
                if (v != null && v.length == 16) {
                    this.rawData = v;
                } else {
                    this.rawData = [
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        1
                    ];
                }
            }
            Matrix3D.prototype.append = function (lhs) {
                var m111 = this.rawData[0], m121 = this.rawData[4], m131 = this.rawData[8], m141 = this.rawData[12], m112 = this.rawData[1], m122 = this.rawData[5], m132 = this.rawData[9], m142 = this.rawData[13], m113 = this.rawData[2], m123 = this.rawData[6], m133 = this.rawData[10], m143 = this.rawData[14], m114 = this.rawData[3], m124 = this.rawData[7], m134 = this.rawData[11], m144 = this.rawData[15], m211 = lhs.rawData[0], m221 = lhs.rawData[4], m231 = lhs.rawData[8], m241 = lhs.rawData[12], m212 = lhs.rawData[1], m222 = lhs.rawData[5], m232 = lhs.rawData[9], m242 = lhs.rawData[13], m213 = lhs.rawData[2], m223 = lhs.rawData[6], m233 = lhs.rawData[10], m243 = lhs.rawData[14], m214 = lhs.rawData[3], m224 = lhs.rawData[7], m234 = lhs.rawData[11], m244 = lhs.rawData[15];

                this.rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
                this.rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
                this.rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
                this.rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;

                this.rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
                this.rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
                this.rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
                this.rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;

                this.rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
                this.rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
                this.rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
                this.rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;

                this.rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
                this.rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
                this.rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
                this.rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
            };

            Matrix3D.prototype.appendRotation = function (degrees, axis, pivotPoint) {
                if (typeof pivotPoint === "undefined") { pivotPoint = null; }
                var m = Matrix3D.getAxisRotation(axis.x, axis.y, axis.z, degrees);

                if (pivotPoint != null) {
                    var p = pivotPoint;
                    m.appendTranslation(p.x, p.y, p.z);
                }

                this.append(m);
            };

            Matrix3D.prototype.appendScale = function (xScale, yScale, zScale) {
                this.append(new Matrix3D([xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0]));
            };

            Matrix3D.prototype.appendTranslation = function (x, y, z) {
                this.rawData[12] += x;
                this.rawData[13] += y;
                this.rawData[14] += z;
            };

            Matrix3D.prototype.clone = function () {
                return new Matrix3D(this.rawData.slice(0));
            };

            Matrix3D.prototype.copyColumnFrom = function (column, vector3D) {
                switch (column) {
                    case 0:
                        vector3D.x = this.rawData[0];
                        vector3D.y = this.rawData[4];
                        vector3D.z = this.rawData[8];
                        vector3D.w = this.rawData[12];
                        break;
                    case 1:
                        vector3D.x = this.rawData[1];
                        vector3D.y = this.rawData[5];
                        vector3D.z = this.rawData[9];
                        vector3D.w = this.rawData[13];
                        break;
                    case 2:
                        vector3D.x = this.rawData[2];
                        vector3D.y = this.rawData[6];
                        vector3D.z = this.rawData[10];
                        vector3D.w = this.rawData[14];
                        break;
                    case 3:
                        vector3D.x = this.rawData[3];
                        vector3D.y = this.rawData[7];
                        vector3D.z = this.rawData[11];
                        vector3D.w = this.rawData[15];
                        break;
                    default:
                        throw new away.errors.ArgumentError("ArgumentError, Column " + column + " out of bounds [0, ..., 3]");
                }
            };

            Matrix3D.prototype.copyColumnTo = function (column, vector3D) {
                switch (column) {
                    case 0:
                        this.rawData[0] = vector3D.x;
                        this.rawData[4] = vector3D.y;
                        this.rawData[8] = vector3D.z;
                        this.rawData[12] = vector3D.w;
                        break;
                    case 1:
                        this.rawData[1] = vector3D.x;
                        this.rawData[5] = vector3D.y;
                        this.rawData[9] = vector3D.z;
                        this.rawData[13] = vector3D.w;
                        break;
                    case 2:
                        this.rawData[2] = vector3D.x;
                        this.rawData[6] = vector3D.y;
                        this.rawData[10] = vector3D.z;
                        this.rawData[14] = vector3D.w;
                        break;
                    case 3:
                        this.rawData[3] = vector3D.x;
                        this.rawData[7] = vector3D.y;
                        this.rawData[11] = vector3D.z;
                        this.rawData[15] = vector3D.w;
                        break;
                    default:
                        throw new away.errors.ArgumentError("ArgumentError, Column " + column + " out of bounds [0, ..., 3]");
                }
            };

            Matrix3D.prototype.copyFrom = function (sourceMatrix3D) {
                this.rawData = sourceMatrix3D.rawData.slice(0);
            };

            Matrix3D.prototype.copyRawDataFrom = function (vector, index, transpose) {
                if (typeof index === "undefined") { index = 0; }
                if (typeof transpose === "undefined") { transpose = false; }
                this.rawData = vector.splice(0);
            };

            Matrix3D.prototype.copyRowFrom = function (row, vector3D) {
                switch (row) {
                    case 0:
                        vector3D.x = this.rawData[0];
                        vector3D.y = this.rawData[1];
                        vector3D.z = this.rawData[2];
                        vector3D.w = this.rawData[3];
                        break;
                    case 1:
                        vector3D.x = this.rawData[4];
                        vector3D.y = this.rawData[5];
                        vector3D.z = this.rawData[6];
                        vector3D.w = this.rawData[7];
                        break;
                    case 2:
                        vector3D.x = this.rawData[8];
                        vector3D.y = this.rawData[9];
                        vector3D.z = this.rawData[10];
                        vector3D.w = this.rawData[11];
                        break;
                    case 3:
                        vector3D.x = this.rawData[12];
                        vector3D.y = this.rawData[13];
                        vector3D.z = this.rawData[14];
                        vector3D.w = this.rawData[15];
                        break;
                    default:
                        throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 3]");
                }
            };

            Matrix3D.prototype.copyRowTo = function (row, vector3D) {
                switch (row) {
                    case 0:
                        this.rawData[0] = vector3D.x;
                        this.rawData[1] = vector3D.y;
                        this.rawData[2] = vector3D.z;
                        this.rawData[3] = vector3D.w;
                        break;
                    case 1:
                        this.rawData[4] = vector3D.x;
                        this.rawData[5] = vector3D.y;
                        this.rawData[6] = vector3D.z;
                        this.rawData[7] = vector3D.w;
                        break;
                    case 2:
                        this.rawData[8] = vector3D.x;
                        this.rawData[9] = vector3D.y;
                        this.rawData[10] = vector3D.z;
                        this.rawData[11] = vector3D.w;
                        break;
                    case 3:
                        this.rawData[12] = vector3D.x;
                        this.rawData[13] = vector3D.y;
                        this.rawData[14] = vector3D.z;
                        this.rawData[15] = vector3D.w;
                        break;
                    default:
                        throw new away.errors.ArgumentError("ArgumentError, Row " + row + " out of bounds [0, ..., 3]");
                }
            };

            Matrix3D.prototype.copyToMatrix3D = function (dest) {
                dest.rawData = this.rawData.slice(0);
            };

            Matrix3D.prototype.decompose = function () {
                var vec = [];
                var m = this.clone();
                var mr = m.rawData;

                var pos = new geom.Vector3D(mr[12], mr[13], mr[14]);
                mr[12] = 0;
                mr[13] = 0;
                mr[14] = 0;

                var scale = new geom.Vector3D();

                scale.x = Math.sqrt(mr[0] * mr[0] + mr[1] * mr[1] + mr[2] * mr[2]);
                scale.y = Math.sqrt(mr[4] * mr[4] + mr[5] * mr[5] + mr[6] * mr[6]);
                scale.z = Math.sqrt(mr[8] * mr[8] + mr[9] * mr[9] + mr[10] * mr[10]);

                if (mr[0] * (mr[5] * mr[10] - mr[6] * mr[9]) - mr[1] * (mr[4] * mr[10] - mr[6] * mr[8]) + mr[2] * (mr[4] * mr[9] - mr[5] * mr[8]) < 0) {
                    scale.z = -scale.z;
                }

                mr[0] /= scale.x;
                mr[1] /= scale.x;
                mr[2] /= scale.x;
                mr[4] /= scale.y;
                mr[5] /= scale.y;
                mr[6] /= scale.y;
                mr[8] /= scale.z;
                mr[9] /= scale.z;
                mr[10] /= scale.z;

                var rot = new geom.Vector3D();
                rot.y = Math.asin(-mr[2]);
                var cos = Math.cos(rot.y);

                if (cos > 0) {
                    rot.x = Math.atan2(mr[6], mr[10]);
                    rot.z = Math.atan2(mr[1], mr[0]);
                } else {
                    rot.z = 0;
                    rot.x = Math.atan2(mr[4], mr[5]);
                }

                vec.push(pos);
                vec.push(rot);
                vec.push(scale);

                return vec;
            };

            Matrix3D.prototype.deltaTransformVector = function (v) {
                var x = v.x, y = v.y, z = v.z;
                return new geom.Vector3D((x * this.rawData[0] + y * this.rawData[1] + z * this.rawData[2] + this.rawData[3]), (x * this.rawData[4] + y * this.rawData[5] + z * this.rawData[6] + this.rawData[7]), (x * this.rawData[8] + y * this.rawData[9] + z * this.rawData[10] + this.rawData[11]), 0);
            };

            Matrix3D.prototype.identity = function () {
                this.rawData = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
            };

            Matrix3D.interpolate = function (thisMat, toMat, percent) {
                var m = new Matrix3D();
                for (var i = 0; i < 16; ++i) {
                    m.rawData[i] = thisMat.rawData[i] + (toMat.rawData[i] - thisMat.rawData[i]) * percent;
                }
                return m;
            };

            Matrix3D.prototype.interpolateTo = function (toMat, percent) {
                for (var i = 0; i < 16; ++i) {
                    this.rawData[i] = this.rawData[i] + (toMat.rawData[i] - this.rawData[i]) * percent;
                }
            };

            Matrix3D.prototype.invert = function () {
                var d = this.determinant;
                var invertable = Math.abs(d) > 0.00000000001;

                if (invertable) {
                    d = -1 / d;
                    var m11 = this.rawData[0];
                    var m21 = this.rawData[4];
                    var m31 = this.rawData[8];
                    var m41 = this.rawData[12];
                    var m12 = this.rawData[1];
                    var m22 = this.rawData[5];
                    var m32 = this.rawData[9];
                    var m42 = this.rawData[13];
                    var m13 = this.rawData[2];
                    var m23 = this.rawData[6];
                    var m33 = this.rawData[10];
                    var m43 = this.rawData[14];
                    var m14 = this.rawData[3];
                    var m24 = this.rawData[7];
                    var m34 = this.rawData[11];
                    var m44 = this.rawData[15];

                    this.rawData[0] = d * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
                    this.rawData[1] = -d * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
                    this.rawData[2] = d * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
                    this.rawData[3] = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
                    this.rawData[4] = -d * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
                    this.rawData[5] = d * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
                    this.rawData[6] = -d * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
                    this.rawData[7] = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
                    this.rawData[8] = d * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
                    this.rawData[9] = -d * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
                    this.rawData[10] = d * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
                    this.rawData[11] = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
                    this.rawData[12] = -d * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
                    this.rawData[13] = d * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
                    this.rawData[14] = -d * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
                    this.rawData[15] = d * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));
                }
                return invertable;
            };

            Matrix3D.prototype.prepend = function (rhs) {
                var m111 = rhs.rawData[0], m121 = rhs.rawData[4], m131 = rhs.rawData[8], m141 = rhs.rawData[12], m112 = rhs.rawData[1], m122 = rhs.rawData[5], m132 = rhs.rawData[9], m142 = rhs.rawData[13], m113 = rhs.rawData[2], m123 = rhs.rawData[6], m133 = rhs.rawData[10], m143 = rhs.rawData[14], m114 = rhs.rawData[3], m124 = rhs.rawData[7], m134 = rhs.rawData[11], m144 = rhs.rawData[15], m211 = this.rawData[0], m221 = this.rawData[4], m231 = this.rawData[8], m241 = this.rawData[12], m212 = this.rawData[1], m222 = this.rawData[5], m232 = this.rawData[9], m242 = this.rawData[13], m213 = this.rawData[2], m223 = this.rawData[6], m233 = this.rawData[10], m243 = this.rawData[14], m214 = this.rawData[3], m224 = this.rawData[7], m234 = this.rawData[11], m244 = this.rawData[15];

                this.rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
                this.rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
                this.rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
                this.rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;

                this.rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
                this.rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
                this.rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
                this.rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;

                this.rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
                this.rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
                this.rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
                this.rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;

                this.rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
                this.rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
                this.rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
                this.rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
            };

            Matrix3D.prototype.prependRotation = function (degrees, axis, pivotPoint) {
                if (typeof pivotPoint === "undefined") { pivotPoint = null; }
                var m = Matrix3D.getAxisRotation(axis.x, axis.y, axis.z, degrees);
                if (pivotPoint != null) {
                    var p = pivotPoint;
                    m.appendTranslation(p.x, p.y, p.z);
                }
                this.prepend(m);
            };

            Matrix3D.prototype.prependScale = function (xScale, yScale, zScale) {
                this.prepend(new Matrix3D([xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, 0, 0, 0, 1]));
            };

            Matrix3D.prototype.prependTranslation = function (x, y, z) {
                var m = new Matrix3D();
                m.position = new geom.Vector3D(x, y, z);
                this.prepend(m);
            };

            Matrix3D.prototype.recompose = function (components) {
                if (components.length < 3 || components[2].x == 0 || components[2].y == 0 || components[2].z == 0)
                    return false;

                this.identity();
                this.appendScale(components[2].x, components[2].y, components[2].z);

                var angle;
                angle = -components[1].x;
                this.append(new Matrix3D([1, 0, 0, 0, 0, Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0, 0]));
                angle = -components[1].y;
                this.append(new Matrix3D([Math.cos(angle), 0, Math.sin(angle), 0, 0, 1, 0, 0, -Math.sin(angle), 0, Math.cos(angle), 0, 0, 0, 0, 0]));
                angle = -components[1].z;
                this.append(new Matrix3D([Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));

                this.position = components[0];
                this.rawData[15] = 1;

                return true;
            };

            Matrix3D.prototype.transformVectors = function (vin, vout) {
                var i = 0;
                var x = 0, y = 0, z = 0;

                while (i + 3 <= vin.length) {
                    x = vin[i];
                    y = vin[i + 1];
                    z = vin[i + 2];
                    vout[i] = x * this.rawData[0] + y * this.rawData[4] + z * this.rawData[8] + this.rawData[12];
                    vout[i + 1] = x * this.rawData[1] + y * this.rawData[5] + z * this.rawData[9] + this.rawData[13];
                    vout[i + 2] = x * this.rawData[2] + y * this.rawData[6] + z * this.rawData[10] + this.rawData[14];
                    i += 3;
                }
            };

            Matrix3D.prototype.transpose = function () {
                var oRawData = this.rawData.slice(0);

                this.rawData[1] = oRawData[4];
                this.rawData[2] = oRawData[8];
                this.rawData[3] = oRawData[12];
                this.rawData[4] = oRawData[1];
                this.rawData[6] = oRawData[9];
                this.rawData[7] = oRawData[13];
                this.rawData[8] = oRawData[2];
                this.rawData[9] = oRawData[6];
                this.rawData[11] = oRawData[14];
                this.rawData[12] = oRawData[3];
                this.rawData[13] = oRawData[7];
                this.rawData[14] = oRawData[11];
            };

            Matrix3D.getAxisRotation = function (x, y, z, degrees) {
                var m = new Matrix3D();

                var a1 = new geom.Vector3D(x, y, z);
                var rad = -degrees * (Math.PI / 180);
                var c = Math.cos(rad);
                var s = Math.sin(rad);
                var t = 1.0 - c;

                m.rawData[0] = c + a1.x * a1.x * t;
                m.rawData[5] = c + a1.y * a1.y * t;
                m.rawData[10] = c + a1.z * a1.z * t;

                var tmp1 = a1.x * a1.y * t;
                var tmp2 = a1.z * s;
                m.rawData[4] = tmp1 + tmp2;
                m.rawData[1] = tmp1 - tmp2;
                tmp1 = a1.x * a1.z * t;
                tmp2 = a1.y * s;
                m.rawData[8] = tmp1 - tmp2;
                m.rawData[2] = tmp1 + tmp2;
                tmp1 = a1.y * a1.z * t;
                tmp2 = a1.x * s;
                m.rawData[9] = tmp1 + tmp2;
                m.rawData[6] = tmp1 - tmp2;

                return m;
            };

            Object.defineProperty(Matrix3D.prototype, "determinant", {
                get: function () {
                    return -1 * ((this.rawData[0] * this.rawData[5] - this.rawData[4] * this.rawData[1]) * (this.rawData[10] * this.rawData[15] - this.rawData[14] * this.rawData[11]) - (this.rawData[0] * this.rawData[9] - this.rawData[8] * this.rawData[1]) * (this.rawData[6] * this.rawData[15] - this.rawData[14] * this.rawData[7]) + (this.rawData[0] * this.rawData[13] - this.rawData[12] * this.rawData[1]) * (this.rawData[6] * this.rawData[11] - this.rawData[10] * this.rawData[7]) + (this.rawData[4] * this.rawData[9] - this.rawData[8] * this.rawData[5]) * (this.rawData[2] * this.rawData[15] - this.rawData[14] * this.rawData[3]) - (this.rawData[4] * this.rawData[13] - this.rawData[12] * this.rawData[5]) * (this.rawData[2] * this.rawData[11] - this.rawData[10] * this.rawData[3]) + (this.rawData[8] * this.rawData[13] - this.rawData[12] * this.rawData[9]) * (this.rawData[2] * this.rawData[7] - this.rawData[6] * this.rawData[3]));
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Matrix3D.prototype, "position", {
                get: function () {
                    return new geom.Vector3D(this.rawData[12], this.rawData[13], this.rawData[14]);
                },
                set: function (value) {
                    this.rawData[12] = value.x;
                    this.rawData[13] = value.y;
                    this.rawData[14] = value.z;
                },
                enumerable: true,
                configurable: true
            });

            return Matrix3D;
        })();
        geom.Matrix3D = Matrix3D;
    })(away.geom || (away.geom = {}));
    var geom = away.geom;
})(away || (away = {}));
var away;
(function (away) {
    (function (geom) {
        var Point = (function () {
            function Point(x, y) {
                if (typeof x === "undefined") { x = 0; }
                if (typeof y === "undefined") { y = 0; }
                this.x = x;
                this.y = y;
            }
            return Point;
        })();
        geom.Point = Point;
    })(away.geom || (away.geom = {}));
    var geom = away.geom;
})(away || (away = {}));
var away;
(function (away) {
    (function (geom) {
        var Rectangle = (function () {
            function Rectangle(x, y, width, height) {
                if (typeof x === "undefined") { x = 0; }
                if (typeof y === "undefined") { y = 0; }
                if (typeof width === "undefined") { width = 0; }
                if (typeof height === "undefined") { height = 0; }
                this.x = x;
                this.y = y;
                this.width = width;
                this.height = height;
            }
            Object.defineProperty(Rectangle.prototype, "left", {
                get: function () {
                    return this.x;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Rectangle.prototype, "right", {
                get: function () {
                    return this.x + this.width;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Rectangle.prototype, "top", {
                get: function () {
                    return this.y;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Rectangle.prototype, "bottom", {
                get: function () {
                    return this.y + this.height;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Rectangle.prototype, "topLeft", {
                get: function () {
                    return new away.geom.Point(this.x, this.y);
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Rectangle.prototype, "bottomRight", {
                get: function () {
                    return new away.geom.Point(this.x + this.width, this.y + this.height);
                },
                enumerable: true,
                configurable: true
            });

            Rectangle.prototype.clone = function () {
                return new Rectangle(this.x, this.y, this.width, this.height);
            };
            return Rectangle;
        })();
        geom.Rectangle = Rectangle;
    })(away.geom || (away.geom = {}));
    var geom = away.geom;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3DTextureFormat = (function () {
            function Context3DTextureFormat() {
            }
            Context3DTextureFormat.BGRA = "bgra";
            Context3DTextureFormat.BGRA_PACKED = "bgraPacked4444";
            Context3DTextureFormat.BGR_PACKED = "bgrPacked565";
            Context3DTextureFormat.COMPRESSED = "compressed";
            Context3DTextureFormat.COMPRESSED_ALPHA = "compressedAlpha";
            return Context3DTextureFormat;
        })();
        display3D.Context3DTextureFormat = Context3DTextureFormat;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var TextureBase = (function () {
            function TextureBase() {
                this._glTexture = GL.createTexture();
            }
            TextureBase.prototype.dispose = function () {
                GL.deleteTexture(this._glTexture);
            };

            Object.defineProperty(TextureBase.prototype, "glTexture", {
                get: function () {
                    return this._glTexture;
                },
                enumerable: true,
                configurable: true
            });
            return TextureBase;
        })();
        display3D.TextureBase = TextureBase;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Texture = (function (_super) {
            __extends(Texture, _super);
            function Texture(width, height) {
                _super.call(this);
                this._width = width;
                this._height = height;

                GL.bindTexture(GL.TEXTURE_2D, this.glTexture);
                GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
            }
            Object.defineProperty(Texture.prototype, "width", {
                get: function () {
                    return this._width;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Texture.prototype, "height", {
                get: function () {
                    return this._height;
                },
                enumerable: true,
                configurable: true
            });

            Texture.prototype.uploadFromHTMLImageElement = function (image, miplevel) {
                if (typeof miplevel === "undefined") { miplevel = 0; }

                console.log('miplevel = ' + miplevel);
                console.log(image);

                GL.texImage2D(GL.TEXTURE_2D, miplevel, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image);
            };
            return Texture;
        })(display3D.TextureBase);
        display3D.Texture = Texture;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3DTriangleFace = (function () {
            function Context3DTriangleFace() {
            }
            Context3DTriangleFace.BACK = "back";
            Context3DTriangleFace.FRONT = "front";
            Context3DTriangleFace.FRONT_AND_BACK = "frontAndBack";
            Context3DTriangleFace.NONE = "none";
            return Context3DTriangleFace;
        })();
        display3D.Context3DTriangleFace = Context3DTriangleFace;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3DVertexBufferFormat = (function () {
            function Context3DVertexBufferFormat() {
            }
            Context3DVertexBufferFormat.BYTES_4 = "bytes4";
            Context3DVertexBufferFormat.FLOAT_1 = "float1";
            Context3DVertexBufferFormat.FLOAT_2 = "float2";
            Context3DVertexBufferFormat.FLOAT_3 = "float3";
            Context3DVertexBufferFormat.FLOAT_4 = "float4";
            return Context3DVertexBufferFormat;
        })();
        display3D.Context3DVertexBufferFormat = Context3DVertexBufferFormat;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3DProgramType = (function () {
            function Context3DProgramType() {
            }
            Context3DProgramType.FRAGMENT = "fragment";
            Context3DProgramType.VERTEX = "vertex";
            return Context3DProgramType;
        })();
        display3D.Context3DProgramType = Context3DProgramType;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display3D) {
        var Context3D = (function () {
            function Context3D(canvas) {
                this._indexBufferList = [];
                this._vertexBufferList = [];
                this._textureList = [];
                this._programList = [];
                try  {
                    GL = canvas.getContext("experimental-webgl");
                    if (!GL) {
                        GL = canvas.getContext("webgl");
                    }
                } catch (e) {
                }

                if (GL) {
                } else {
                    alert("WebGL is not available.");
                }
            }
            Context3D.prototype.clear = function (red, green, blue, alpha, depth, stencil, mask) {
                if (typeof red === "undefined") { red = 0; }
                if (typeof green === "undefined") { green = 0; }
                if (typeof blue === "undefined") { blue = 0; }
                if (typeof alpha === "undefined") { alpha = 1; }
                if (typeof depth === "undefined") { depth = 1; }
                if (typeof stencil === "undefined") { stencil = 0; }
                if (typeof mask === "undefined") { mask = display3D.Context3DClearMask.ALL; }

                if (!this._drawing) {
                    this.updateBlendStatus();
                    this._drawing = true;
                }
                GL.clearColor(red, green, blue, alpha);
                GL.clearDepth(depth);
                GL.clearStencil(stencil);
                GL.clear(mask);
            };

            Context3D.prototype.configureBackBuffer = function (width, height, antiAlias, enableDepthAndStencil) {
                if (typeof enableDepthAndStencil === "undefined") { enableDepthAndStencil = true; }

                if (enableDepthAndStencil) {
                    GL.enable(GL.STENCIL_TEST);
                    GL.enable(GL.DEPTH_TEST);
                }

                GL.viewport.width = width;
                GL.viewport.height = height;
            };

            Context3D.prototype.createIndexBuffer = function (numIndices) {
                var indexBuffer = new away.display3D.IndexBuffer3D(numIndices);
                this._indexBufferList.push(indexBuffer);
                return indexBuffer;
            };

            Context3D.prototype.createProgram = function () {
                var program = new away.display3D.Program3D();
                this._programList.push(program);
                return program;
            };

            Context3D.prototype.createTexture = function (width, height, format, optimizeForRenderToTexture, streamingLevels) {
                if (typeof streamingLevels === "undefined") { streamingLevels = 0; }

                var texture = new away.display3D.Texture(width, height);
                this._textureList.push(texture);
                return texture;
            };

            Context3D.prototype.createVertexBuffer = function (numVertices, data32PerVertex) {
                var vertexBuffer = new away.display3D.VertexBuffer3D(numVertices, data32PerVertex);
                this._vertexBufferList.push(vertexBuffer);
                return vertexBuffer;
            };

            Context3D.prototype.dispose = function () {
                var i;
                for (i = 0; i < this._indexBufferList.length; ++i) {
                    this._indexBufferList[i].dispose();
                }
                this._indexBufferList = null;

                for (i = 0; i < this._vertexBufferList.length; ++i) {
                    this._vertexBufferList[i].dispose();
                }
                this._vertexBufferList = null;

                for (i = 0; i < this._textureList.length; ++i) {
                    this._textureList[i].dispose();
                }
                this._textureList = null;

                for (i = 0; i < this._programList.length; ++i) {
                    this._programList[i].dispose();
                }
                this._programList = null;
            };

            Context3D.prototype.drawTriangles = function (indexBuffer, firstIndex, numTriangles) {
                if (typeof firstIndex === "undefined") { firstIndex = 0; }
                if (typeof numTriangles === "undefined") { numTriangles = -1; }

                if (!this._drawing) {
                    throw "Need to clear before drawing if the buffer has not been cleared since the last present() call.";
                }
                var numIndices = 0;

                if (numTriangles == -1) {
                    numIndices = indexBuffer.numIndices;
                } else {
                    numIndices = numTriangles * 3;
                }

                GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer.glBuffer);
                GL.drawElements(GL.TRIANGLES, numIndices, GL.UNSIGNED_SHORT, firstIndex);
            };

            Context3D.prototype.present = function () {
                this._drawing = false;
                GL.useProgram(null);
            };

            Context3D.prototype.setBlendFactors = function (sourceFactor, destinationFactor) {
                console.log("===== setBlendFactors =====");
                console.log("\tsourceFactor: " + sourceFactor);
                console.log("\tdestinationFactor: " + destinationFactor);
                this._blendEnabled = true;
                this._blendSourceFactor = sourceFactor;
                this._blendDestinationFactor = destinationFactor;

                this.updateBlendStatus();
            };

            Context3D.prototype.setColorMask = function (red, green, blue, alpha) {
                console.log("===== setColorMask =====");
                GL.colorMask(red, green, blue, alpha);
            };

            Context3D.prototype.setCulling = function (triangleFaceToCull) {
                console.log("===== setCulling =====");
                console.log("\ttriangleFaceToCull: " + triangleFaceToCull);
                if (triangleFaceToCull == display3D.Context3DTriangleFace.NONE) {
                    GL.disable(GL.CULL_FACE);
                } else {
                    GL.enable(GL.CULL_FACE);
                    switch (triangleFaceToCull) {
                        case display3D.Context3DTriangleFace.FRONT:
                            GL.cullFace(GL.FRONT);
                            break;
                        case display3D.Context3DTriangleFace.BACK:
                            GL.cullFace(GL.BACK);
                            break;
                        case display3D.Context3DTriangleFace.FRONT_AND_BACK:
                            GL.cullFace(GL.FRONT_AND_BACK);
                            break;
                        default:
                            throw "Unknown Context3DTriangleFace type.";
                    }
                }
            };

            Context3D.prototype.setDepthTest = function (depthMask, passCompareMode) {
                console.log("===== setDepthTest =====");
                console.log("\tdepthMask: " + depthMask);
                console.log("\tpassCompareMode: " + passCompareMode);
                GL.depthFunc(passCompareMode);
                GL.depthMask(depthMask);
            };

            Context3D.prototype.setProgram = function (program3D) {
                console.log("===== setProgram =====");

                this._currentProgram = program3D;
                program3D.focusProgram();
            };

            Context3D.prototype.getUniformLocationNameFromAgalRegisterIndex = function (programType, firstRegister) {
                switch (programType) {
                    case display3D.Context3DProgramType.VERTEX:
                        return "vc";
                        break;
                    case display3D.Context3DProgramType.FRAGMENT:
                        return "fc";
                        break;
                    default:
                        throw "Program Type " + programType + " not supported";
                }
            };

            Context3D.prototype.setProgramConstantsFromMatrix = function (programType, firstRegister, matrix, transposedMatrix) {
                if (typeof transposedMatrix === "undefined") { transposedMatrix = false; }

                var locationName = this.getUniformLocationNameFromAgalRegisterIndex(programType, firstRegister);
                this.setGLSLProgramConstantsFromMatrix(locationName, matrix, transposedMatrix);
            };

            Context3D.prototype.setGLSLProgramConstantsFromMatrix = function (locationName, matrix, transposedMatrix) {
                if (typeof transposedMatrix === "undefined") { transposedMatrix = false; }

                var location = GL.getUniformLocation(this._currentProgram.glProgram, locationName);
                GL.uniformMatrix4fv(location, !transposedMatrix, new Float32Array(matrix.rawData));
            };

            Context3D.prototype.setGLSLProgramConstantsFromVector4 = function (locationName, data, startIndex) {
                if (typeof startIndex === "undefined") { startIndex = 0; }
                console.log("===== setGLSLProgramConstantsFromVector4 =====");
                console.log("\tlocationName: " + locationName);
                console.log("\tdata: " + data);
                console.log("\tstartIndex: " + startIndex);
                var location = GL.getUniformLocation(this._currentProgram.glProgram, locationName);
                GL.uniform4f(location, data[startIndex], data[startIndex + 1], data[startIndex + 2], data[startIndex + 3]);
            };

            Context3D.prototype.setScissorRectangle = function (rectangle) {
                console.log("===== setScissorRectangle =====");
                console.log("\trectangle: " + rectangle);
                GL.scissor(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
            };

            Context3D.prototype.setGLSLTextureAt = function (locationName, texture, textureIndex) {
                console.log('locationName = ' + locationName);
                console.log(texture);
                console.log('textureIndex = ' + textureIndex);
                var location = GL.getUniformLocation(this._currentProgram.glProgram, locationName);
                console.log(location);
                switch (textureIndex) {
                    case 0:
                        GL.activeTexture(GL.TEXTURE0);
                        break;
                    case 1:
                        GL.activeTexture(GL.TEXTURE1);
                        break;
                    case 2:
                        GL.activeTexture(GL.TEXTURE2);
                        break;
                    case 3:
                        GL.activeTexture(GL.TEXTURE3);
                        break;
                    case 4:
                        GL.activeTexture(GL.TEXTURE4);
                        break;
                    case 5:
                        GL.activeTexture(GL.TEXTURE5);
                        break;
                    case 6:
                        GL.activeTexture(GL.TEXTURE6);
                        break;
                    case 7:
                        GL.activeTexture(GL.TEXTURE7);
                        break;
                    default:
                        throw "Texture " + textureIndex + " is out of bounds.";
                }

                GL.bindTexture(GL.TEXTURE_2D, texture.glTexture);
                GL.uniform1i(location, textureIndex);

                GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
                GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
                GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
                GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
            };

            Context3D.prototype.setVertexBufferAt = function (index, buffer, bufferOffset, format) {
                if (typeof bufferOffset === "undefined") { bufferOffset = 0; }
                if (typeof format === "undefined") { format = null; }

                var locationName = "va" + index;
                this.setGLSLVertexBufferAt(locationName, buffer, bufferOffset, format);
            };

            Context3D.prototype.setGLSLVertexBufferAt = function (locationName, buffer, bufferOffset, format) {
                if (typeof bufferOffset === "undefined") { bufferOffset = 0; }
                if (typeof format === "undefined") { format = null; }

                var location = GL.getAttribLocation(this._currentProgram.glProgram, locationName);

                GL.bindBuffer(GL.ARRAY_BUFFER, buffer.glBuffer);

                var dimension;
                var type = GL.FLOAT;
                var numBytes = 4;

                switch (format) {
                    case display3D.Context3DVertexBufferFormat.BYTES_4:
                        dimension = 4;
                        break;
                    case display3D.Context3DVertexBufferFormat.FLOAT_1:
                        dimension = 1;
                        break;
                    case display3D.Context3DVertexBufferFormat.FLOAT_2:
                        dimension = 2;
                        break;
                    case display3D.Context3DVertexBufferFormat.FLOAT_3:
                        dimension = 3;
                        break;
                    case display3D.Context3DVertexBufferFormat.FLOAT_4:
                        dimension = 4;
                        break;
                    default:
                        throw "Buffer format " + format + " is not supported.";
                }

                GL.enableVertexAttribArray(location);
                GL.vertexAttribPointer(location, dimension, type, false, buffer.data32PerVertex * numBytes, bufferOffset * numBytes);
            };

            Context3D.prototype.updateBlendStatus = function () {
                console.log("===== updateBlendStatus =====");
                if (this._blendEnabled) {
                    GL.enable(GL.BLEND);
                    GL.blendEquation(GL.FUNC_ADD);
                    GL.blendFunc(this._blendSourceFactor, this._blendDestinationFactor);
                } else {
                    GL.disable(GL.BLEND);
                }
            };
            return Context3D;
        })();
        display3D.Context3D = Context3D;
    })(away.display3D || (away.display3D = {}));
    var display3D = away.display3D;
})(away || (away = {}));
var away;
(function (away) {
    (function (display) {
        var Stage3D = (function (_super) {
            __extends(Stage3D, _super);
            function Stage3D(canvas) {
                _super.call(this);
                this._canvas = canvas;
            }
            Stage3D.prototype.requestContext = function () {
                try  {
                    this._context3D = new away.display3D.Context3D(this._canvas);
                } catch (e) {
                    this.dispatchEvent(new away.events.AwayEvent(away.events.AwayEvent.ERROR, e));
                }

                if (this._context3D) {
                    this.dispatchEvent(new away.events.AwayEvent(away.events.AwayEvent.CONTEXT3D_CREATE));
                }
            };

            Object.defineProperty(Stage3D.prototype, "canvas", {
                get: function () {
                    return this._canvas;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(Stage3D.prototype, "context3D", {
                get: function () {
                    return this._context3D;
                },
                enumerable: true,
                configurable: true
            });
            return Stage3D;
        })(away.events.EventDispatcher);
        display.Stage3D = Stage3D;
    })(away.display || (away.display = {}));
    var display = away.display;
})(away || (away = {}));
var away;
(function (away) {
    (function (display) {
        var Stage = (function () {
            function Stage(width, height) {
                if (typeof width === "undefined") { width = 640; }
                if (typeof height === "undefined") { height = 480; }
                if (!document) {
                    throw "Error: document does not exist.";
                }

                this.initStage3DObjects();
                this.resize(width, height);
            }
            Stage.prototype.resize = function (width, height) {
                this._stageHeight = height;
                this._stageWidth = width;

                for (var i = 0; i < Stage.MAX_STAGE3D_QUANTITY; ++i) {
                    this.stage3Ds[i].canvas.style.width = width + "px";
                    this.stage3Ds[i].canvas.style.height = height + "px";
                    this.stage3Ds[i].canvas.width = width;
                    this.stage3Ds[i].canvas.height = height;
                }
            };

            Stage.prototype.getStage3DAt = function (index) {
                if (0 <= index && index < Stage.MAX_STAGE3D_QUANTITY) {
                    return this.stage3Ds[index];
                }
                throw "Index is out of bounds";
            };

            Stage.prototype.initStage3DObjects = function () {
                this.stage3Ds = [];
                for (var i = 0; i < Stage.MAX_STAGE3D_QUANTITY; ++i) {
                    var canvas = this.createHTMLCanvasElement();
                    this.addChildHTMLElement(canvas);
                    this.stage3Ds.push(new away.display.Stage3D(canvas));
                }
            };

            Stage.prototype.createHTMLCanvasElement = function () {
                return document.createElement("canvas");
            };

            Stage.prototype.addChildHTMLElement = function (canvas) {
                document.body.appendChild(canvas);
            };
            Stage.MAX_STAGE3D_QUANTITY = 8;
            return Stage;
        })();
        display.Stage = Stage;
    })(away.display || (away.display = {}));
    var display = away.display;
})(away || (away = {}));
var away;
(function (away) {
    (function (utils) {
        var PerspectiveMatrix3D = (function (_super) {
            __extends(PerspectiveMatrix3D, _super);
            function PerspectiveMatrix3D(v) {
                if (typeof v === "undefined") { v = null; }
                _super.call(this, v);
            }
            PerspectiveMatrix3D.prototype.perspectiveFieldOfViewLH = function (fieldOfViewY, aspectRatio, zNear, zFar) {
                var yScale = 1 / Math.tan(fieldOfViewY / 2);
                var xScale = yScale / aspectRatio;
                this.copyRawDataFrom([
                    xScale,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    yScale,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    zFar / (zFar - zNear),
                    1.0,
                    0.0,
                    0.0,
                    (zNear * zFar) / (zNear - zFar),
                    0.0
                ]);
            };
            return PerspectiveMatrix3D;
        })(away.geom.Matrix3D);
        utils.PerspectiveMatrix3D = PerspectiveMatrix3D;
    })(away.utils || (away.utils = {}));
    var utils = away.utils;
})(away || (away = {}));
var away;
(function (away) {
    (function (events) {
        var TimerEvent = (function (_super) {
            __extends(TimerEvent, _super);
            function TimerEvent(type) {
                _super.call(this, type);
            }
            TimerEvent.TIMER = "timer";
            TimerEvent.TIMER_COMPLETE = "timerComplete";
            return TimerEvent;
        })(away.events.Event);
        events.TimerEvent = TimerEvent;
    })(away.events || (away.events = {}));
    var events = away.events;
})(away || (away = {}));
var away;
(function (away) {
    (function (utils) {
        function getTimer() {
            return Date.now();
        }
        utils.getTimer = getTimer;
    })(away.utils || (away.utils = {}));
    var utils = away.utils;
})(away || (away = {}));
var away;
(function (away) {
    (function (utils) {
        var RequestAnimationFrame = (function () {
            function RequestAnimationFrame(callback, callbackContext) {
                var _this = this;
                this._active = false;
                this._argsArray = new Array();
                this._getTimer = away.utils.getTimer;

                this.setCallback(callback, callbackContext);

                this._rafUpdateFunction = function () {
                    if (_this._active) {
                        _this._tick();
                    }
                };

                this._argsArray.push(this._dt);
            }
            RequestAnimationFrame.prototype.setCallback = function (callback, callbackContext) {
                this._callback = callback;
                this._callbackContext = callbackContext;
            };

            RequestAnimationFrame.prototype.start = function () {
                this._prevTime = this._getTimer();
                this._active = true;

                if (window['mozRequestAnimationFrame']) {
                    window.requestAnimationFrame = window['mozRequestAnimationFrame'];
                } else if (window['webkitRequestAnimationFrame']) {
                    window.requestAnimationFrame = window['webkitRequestAnimationFrame'];
                } else if (window['oRequestAnimationFrame']) {
                    window.requestAnimationFrame = window['oRequestAnimationFrame'];
                }

                if (window.requestAnimationFrame) {
                    window.requestAnimationFrame(this._rafUpdateFunction);
                }
            };

            RequestAnimationFrame.prototype.stop = function () {
                this._active = false;
            };

            Object.defineProperty(RequestAnimationFrame.prototype, "active", {
                get: function () {
                    return this._active;
                },
                enumerable: true,
                configurable: true
            });

            RequestAnimationFrame.prototype._tick = function () {
                this._currentTime = this._getTimer();
                this._dt = this._currentTime - this._prevTime;
                this._argsArray[0] = this._dt;
                this._callback.apply(this._callbackContext, this._argsArray);

                window.requestAnimationFrame(this._rafUpdateFunction);

                this._prevTime = this._currentTime;
            };
            return RequestAnimationFrame;
        })();
        utils.RequestAnimationFrame = RequestAnimationFrame;
    })(away.utils || (away.utils = {}));
    var utils = away.utils;
})(away || (away = {}));
var away;
(function (away) {
    (function (events) {
        var IOErrorEvent = (function (_super) {
            __extends(IOErrorEvent, _super);
            function IOErrorEvent(type) {
                _super.call(this, type);
            }
            IOErrorEvent.IO_ERROR = "IOErrorEvent_IO_ERROR";
            return IOErrorEvent;
        })(away.events.Event);
        events.IOErrorEvent = IOErrorEvent;
    })(away.events || (away.events = {}));
    var events = away.events;
})(away || (away = {}));
var away;
(function (away) {
    (function (net) {
        var URLRequestMethod = (function () {
            function URLRequestMethod() {
            }
            URLRequestMethod.POST = 'POST';

            URLRequestMethod.GET = 'GET';
            return URLRequestMethod;
        })();
        net.URLRequestMethod = URLRequestMethod;
    })(away.net || (away.net = {}));
    var net = away.net;
})(away || (away = {}));
var away;
(function (away) {
    (function (net) {
        var URLVariables = (function () {
            function URLVariables(source) {
                if (typeof source === "undefined") { source = null; }
                this._variables = new Object();
                if (source !== null) {
                    this.decode(source);
                }
            }
            URLVariables.prototype.decode = function (source) {
                source = source.split("+").join(" ");

                var tokens, re = /[?&]?([^=]+)=([^&]*)/g;

                while (tokens = re.exec(source)) {
                    this._variables[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
                }
            };

            URLVariables.prototype.toString = function () {
                return '';
            };

            Object.defineProperty(URLVariables.prototype, "variables", {
                get: function () {
                    return this._variables;
                },
                set: function (obj) {
                    this._variables = obj;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(URLVariables.prototype, "formData", {
                get: function () {
                    var fd = new FormData();

                    for (var s in this._variables) {
                        fd.append(s, this._variables[s]);
                    }

                    return fd;
                },
                enumerable: true,
                configurable: true
            });

            return URLVariables;
        })();
        net.URLVariables = URLVariables;
    })(away.net || (away.net = {}));
    var net = away.net;
})(away || (away = {}));
var away;
(function (away) {
    (function (net) {
        var URLRequest = (function () {
            function URLRequest(url) {
                if (typeof url === "undefined") { url = null; }
                this.method = away.net.URLRequestMethod.GET;
                this.async = true;
                this._url = url;
            }
            Object.defineProperty(URLRequest.prototype, "url", {
                get: function () {
                    return this._url;
                },
                set: function (value) {
                    this._url = value;
                },
                enumerable: true,
                configurable: true
            });


            URLRequest.prototype.dispose = function () {
                this.data = null;
                this._url = null;
                this.method = null;
                this.async = null;
            };
            return URLRequest;
        })();
        net.URLRequest = URLRequest;
    })(away.net || (away.net = {}));
    var net = away.net;
})(away || (away = {}));
var away;
(function (away) {
    (function (net) {
        var IMGLoader = (function (_super) {
            __extends(IMGLoader, _super);
            function IMGLoader(imageName) {
                if (typeof imageName === "undefined") { imageName = ''; }
                _super.call(this);
                this._name = '';
                this._loaded = false;
                this._name = imageName;
                this.initImage();
            }
            IMGLoader.prototype.load = function (request) {
                this._loaded = false;
                this._request = request;

                if (this._crossOrigin) {
                    if (this._image['crossOrigin'] != null) {
                        this._image['crossOrigin'] = this._crossOrigin;
                    }
                }

                this._image.src = this._request.url;
            };

            IMGLoader.prototype.dispose = function () {
                if (this._image) {
                    this._image.onabort = null;
                    this._image.onerror = null;
                    this._image.onload = null;
                    this._image = null;
                }

                if (this._request) {
                    this._request = null;
                }
            };

            Object.defineProperty(IMGLoader.prototype, "image", {
                get: function () {
                    return this._image;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IMGLoader.prototype, "loaded", {
                get: function () {
                    return this._loaded;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IMGLoader.prototype, "crossOrigin", {
                get: function () {
                    return this._crossOrigin;
                },
                set: function (value) {
                    this._crossOrigin = value;
                },
                enumerable: true,
                configurable: true
            });


            Object.defineProperty(IMGLoader.prototype, "width", {
                get: function () {
                    if (this._image) {
                        return this._image.width;
                    }

                    return null;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IMGLoader.prototype, "height", {
                get: function () {
                    if (this._image) {
                        return this._image.height;
                    }

                    return null;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IMGLoader.prototype, "request", {
                get: function () {
                    return this._request;
                },
                enumerable: true,
                configurable: true
            });

            Object.defineProperty(IMGLoader.prototype, "name", {
                get: function () {
                    if (this._image) {
                        return this._image.name;
                    }

                    return this._name;
                },
                set: function (value) {
                    if (this._image) {
                        this._image.name = value;
                    }

                    this._name = value;
                },
                enumerable: true,
                configurable: true
            });


            IMGLoader.prototype.initImage = function () {
                var _this = this;
                if (!this._image) {
                    this._image = new Image();
                    this._image.onabort = function (event) {
                        return _this.onAbort(event);
                    };
                    this._image.onerror = function (event) {
                        return _this.onError(event);
                    };
                    this._image.onload = function (event) {
                        return _this.onLoadComplete(event);
                    };
                    this._image.name = this._name;
                }
            };

            IMGLoader.prototype.onAbort = function (event) {
                this.dispatchEvent(new away.events.Event(away.events.IOErrorEvent.IO_ERROR));
            };

            IMGLoader.prototype.onError = function (event) {
                this.dispatchEvent(new away.events.Event(away.events.IOErrorEvent.IO_ERROR));
            };

            IMGLoader.prototype.onLoadComplete = function (event) {
                this._loaded = true;
                this.dispatchEvent(new away.events.Event(away.events.Event.COMPLETE));
            };
            return IMGLoader;
        })(away.events.EventDispatcher);
        net.IMGLoader = IMGLoader;
    })(away.net || (away.net = {}));
    var net = away.net;
})(away || (away = {}));
var GL = null;

var Away3D = (function (_super) {
    __extends(Away3D, _super);
    function Away3D(stage) {
        _super.call(this);

        if (!document) {
            throw "The document root object must be avaiable";
        }

        this._stage = new away.display.Stage(640, 480);


    }
    Object.defineProperty(Away3D.prototype, "stage", {
        get: function () {
            return this._stage;
        },
        enumerable: true,
        configurable: true
    });


    return Away3D;
})(away.events.EventDispatcher);
