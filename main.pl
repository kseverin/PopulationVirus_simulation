#Kerde Severin - Perl Program 3
# Small World Graph
#! /bin/perl -w


use Graph;
use constant {
  N => 25,											# Population size
  C => 5, 											# Average number of contacts per person, per day
};  

my $g1 = Graph->new;

for($j = 0; $j < N; $j++) {	
	$person[$j]{state} = "susceptible";				#all others are susceptible
	$person[$j]{contacts} = 0;
	$person[$j]{days} = 0;
	$person[$j]{latentdays} = 0;
	$person[$j]{infectiousdays} = 0;
	
	}

$choice = int(rand(N));	
$person[$choice]{state} = "infected";  				 # random person is infected


$contactlimit = N * C;
$numcontacts = 0;


$stateofpop = 1;									#this stays at 1 as long as there are infected or latent

$TR = 0.1;											# Transmission rate is 0.1



while($stateofpop != 0){							#outer loop to keep going till noone is infected or latent
		
		
		
while ($numcontacts <= $contactlimit) {
	$p1 = int(rand(N));								#randomly chose two nodes to start off
	$p2 = int(rand(N));
	while ($p1 == $p2) {
		$p2 = int(rand(N)); }  						# select again if you select the same person 
	$g1->add_edge($p1, $p2);   						# vertices $p1 & $p2 will be added implicitly
	$person[$p1]{contacts}++;
	$person[$p2]{contacts}++;
	$numcontacts += 2;  							#count of contacts

	
		
		
		
if (($person[$p1]{state} eq "susceptible") && ($person[$p2]{state} eq "infected")) {
		$randomnum = int(rand());
		if($randomnum  <= $TR){	
		$person[$p1]{state} = "latent";
		$person[$p1]{latentdays}++;
		 						
		}
	}		

if (($person[$p2]{state} eq "susceptible") && ($person[$p1]{state} eq "infected")) {
		$person[$p2]{state} = "latent"; 
		$person[$p2]{latentdays}++;						
	}	


}

$stateofpop = 0;
for($j = 0; $j < N; $j++) {							#increase day
	$person[$j]{days}++;
	if($person[$j]{state} eq "latent"){ 
		$stateofpop = 1;
		if($person[$j]{latentdays} == 3){ $person[$j]{state} = "infectious" } else{
		$person[$j]{latentdays}++;}
	}
	elsif($person[$j]{state} eq "infectious"){
		$stateofpop = 1; 
		if($person[$j]{infectiousdays} == 2){ $person[$j]{state} = "removed" } else{
		$person[$j]{infectiousdays}++;}
	}	
}

}






@v = $g1->vertices; 	
@e = $g1->edges; 


# Open a dot file
open (OUT, ">people.dot")or die("Error: cannot open file \n");

# Add appropriate comments to the dot file & print the graph information to the file
print OUT "// Kerde Severin \n";
print OUT "graph G { \n";

# Print out each vertex, color coded:  susceptible (purple), removed (red), & latent (brown)
# Node are labeled with the vertex number followed by the number of contacts in parentheses
foreach $vertex (@v) {
	if ($person[$vertex]{state} eq "susceptible") { 						
		print OUT "$vertex [label = \"$vertex ($person[$vertex]{contacts})\", 
				color = purple, style = filled, fillcolor = purple]; \n";	}	
	elsif ($person[$vertex]{state} eq "removed") {
		print OUT "$vertex [label = \"$vertex ($person[$vertex]{contacts})\",
				color = red, style = filled, fillcolor = red]; \n";	}	
	else {
		print OUT "$vertex [label = \"$vertex ($person[$vertex]{contacts})\",
				color = brown, style = filled, fillcolor = brown]; \n";	}
}

# Print out each edge
foreach $edge (@e) {
	
	print OUT "$$edge[0]--$$edge[1]; \n";
}
print OUT "}";  

close OUT;

qx(dot -Tjpg  people.dot -o people.jpg);  # External call to Graphviz 



