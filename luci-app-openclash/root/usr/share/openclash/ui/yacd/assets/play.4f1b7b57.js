var h=Object.defineProperty,d=Object.defineProperties;var w=Object.getOwnPropertyDescriptors;var y=Object.getOwnPropertySymbols;var b=Object.prototype.hasOwnProperty,O=Object.prototype.propertyIsEnumerable;var v=(e,t,r)=>t in e?h(e,t,{enumerable:!0,configurable:!0,writable:!0,value:r}):e[t]=r,p=(e,t)=>{for(var r in t||(t={}))b.call(t,r)&&v(e,r,t[r]);if(y)for(var r of y(t))O.call(t,r)&&v(e,r,t[r]);return e},f=(e,t)=>d(e,w(t));import{r as g,b as j,j as a,P as s}from"./index.834378fe.js";function P(e,t){if(e==null)return{};var r=k(e,t),i,o;if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);for(o=0;o<n.length;o++)i=n[o],!(t.indexOf(i)>=0)&&(!Object.prototype.propertyIsEnumerable.call(e,i)||(r[i]=e[i]))}return r}function k(e,t){if(e==null)return{};var r={},i=Object.keys(e),o,n;for(n=0;n<i.length;n++)o=i[n],!(t.indexOf(o)>=0)&&(r[o]=e[o]);return r}var c=g.exports.forwardRef(function(e,t){var r=e.color,i=r===void 0?"currentColor":r,o=e.size,n=o===void 0?24:o,l=P(e,["color","size"]);return j("svg",f(p({ref:t,xmlns:"http://www.w3.org/2000/svg",width:n,height:n,viewBox:"0 0 24 24",fill:"none",stroke:i,strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},l),{children:[a("rect",{x:"6",y:"4",width:"4",height:"16"}),a("rect",{x:"14",y:"4",width:"4",height:"16"})]}))});c.propTypes={color:s.string,size:s.oneOfType([s.string,s.number])};c.displayName="Pause";var L=c;function x(e,t){if(e==null)return{};var r=m(e,t),i,o;if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);for(o=0;o<n.length;o++)i=n[o],!(t.indexOf(i)>=0)&&(!Object.prototype.propertyIsEnumerable.call(e,i)||(r[i]=e[i]))}return r}function m(e,t){if(e==null)return{};var r={},i=Object.keys(e),o,n;for(n=0;n<i.length;n++)o=i[n],!(t.indexOf(o)>=0)&&(r[o]=e[o]);return r}var u=g.exports.forwardRef(function(e,t){var r=e.color,i=r===void 0?"currentColor":r,o=e.size,n=o===void 0?24:o,l=x(e,["color","size"]);return a("svg",f(p({ref:t,xmlns:"http://www.w3.org/2000/svg",width:n,height:n,viewBox:"0 0 24 24",fill:"none",stroke:i,strokeWidth:"2",strokeLinecap:"round",strokeLinejoin:"round"},l),{children:a("polygon",{points:"5 3 19 12 5 21 5 3"})}))});u.propTypes={color:s.string,size:s.oneOfType([s.string,s.number])};u.displayName="Play";var W=u;export{W as P,L as a};
