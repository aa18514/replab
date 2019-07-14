classdef RepLaws < replab.Laws
    properties
        rep;
        G; % group of which rep is a representation
        C; % commutant algebra
        U; % Unitary/orthonormal matrices on R or C
        M; % n x n matrices over R, or C
    end
    
    methods
        
        function self = RepLaws(rep)
            self.rep = rep;
            d = self.rep.dimension;
            self.G = rep.group;
            self.C = rep.commutant;
            switch rep.field
              case 'R'
                self.U = replab.domain.OrthonormalMatrices(d);
                self.M = replab.domain.RealMatrices(d, d);
              case 'C'
                self.U = replab.domain.UnitaryMatrices(d);
                self.M = replab.domain.ComplexMatrices(d, d);
              otherwise
                error('Unknown field');
            end            
        end
        function morphismLaws = laws_asGroupHomomorphism(self)
            morphismLaws = replab.GroupMorphismLaws(@(g) self.rep.image(g), self.G, self.U);
        end
        function law_commutes_with_commutant_algebra_GC(self, g, c)
            rho = self.rep.image(g);
            self.M.assertEqv(rho*c, c*rho);
        end
    end
end
