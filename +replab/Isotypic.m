classdef Isotypic < replab.Str
% Describes an isotypic component in the decomposition of a representation
    
    properties
        parent;
        copies;
        multiplicity;
        copyDimension;
    end
    
    methods
        
        function self = Isotypic(parent, copies)
            assert(isa(parent, 'replab.Rep'));
            assert(length(copies) >= 1, 'Isotypic component cannot be empty');
            for i = 1:length(copies)
                assert(isa(copies{i}, 'replab.Irrep'));
            end
            self.parent = parent;
            self.copies = copies;
            self.multiplicity = length(copies);
            self.copyDimension = copies{1}.dimension;
        end
        
        function r = rep(self)
        % Returns the subrepresentation corresponding to this isotypic component
            U = zeros(0, self.parent.dimension);
            for i = 1:self.nCopies
                U = [U;self.copy(i).U];
            end
            r = self.parent.subRep(U);
            % TODO: preserve rational bases
        end
        
        function n = nCopies(self)
        % Returns the number of copies = the multiplicity
            n = length(self.copies);
        end
        
        function c = copy(self, i)
        % Returns the i-th copy of the irreducible representation
            c = self.copies{i};
        end
        
        function I = nice(self)
        % Tries to recover "nice" bases for all subrepresentations
            if self.nCopies > 1
                % TODO: handle multiplicities better
                I = self;
            else
                I = replab.Isotypic(self.parent, {self.copy(1).nice});
            end
        end
        
        function names = hiddenFields(self)
            names = hiddenFields@replab.Str(self);
            names{1, end+1} = 'copies';
        end
        
        function [names values] = additionalFields(self)
            [names values] = additionalFields@replab.Str(self);
            for i = 1:self.nCopies
                names{1, end+1} = sprintf('copy(%d)', i);
                values{1, end+1} = self.copy(i);
            end
        end
        
        function s = headerStr(self)
            rt = self.copy(1).realDivisionAlgebra;
            if isequal(rt, [])
                rt = 'C';
            else
                rt = rt.shortName;
            end
            if self.multiplicity > 1
                s = sprintf('Isotypic component I(%d)x%s(%d)', self.multiplicity, rt, self.copyDimension);
            else
                s = sprintf('Isotypic component %s(%d)', rt, self.copyDimension);
            end
        end
        
    end
    
end
