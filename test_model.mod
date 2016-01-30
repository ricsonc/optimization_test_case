/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Ricson Cheng
 * Creation Date: Jan 29, 2016 at 4:11:10 PM
 *********************************************/

{string} Products = ...;
{string} Components = ...;

float profit[Products] = ...;
float amount[Components] = ...;
float cost[Components] = ...;
float size_products[Products] = ...;
float assembly[Products, Components] = ...;

dvar float+ production[Products];
dvar float+ purchase[Components];
dvar int+ size_warehouse;
dvar float+ flexibility;

maximize 
	((piecewise{1 -> 1000; 0.9 -> 4000; 0.8 -> 5000; 0.7} 
      sum(p in Products) profit[p]*production[p])
	 - sum(c in Components) cost[c]*purchase[c]
	 - piecewise{1 -> 10; 4 -> 20; 2 -> 30; 0.1} size_warehouse
	 - piecewise{1 -> 10; 1.1 -> 20; 1.2 -> 30; 2 -> 40; 16} flexibility);

subject to {
	materials: forall(c in Components)
		(amount[c] + purchase[c] >= 
		 sum(p in Products) assembly[p,c] * production[p]);
	space: size_warehouse >= sum(p in Products) size_products[p]*production[p];
	regulatory: forall(p1 in Products) forall(p2 in Products)
		production[p1]-production[p2] <= flexibility;
};