#
# bio/db/pdb/model.rb - model class for PDB
#
#   Copyright (C) 2004 Alex Gutteridge <alexg@ebi.ac.uk>
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
#
#  $Id: model.rb,v 1.3 2006/01/04 15:41:50 ngoto Exp $

require 'bio/db/pdb'

module Bio

  class PDB

    #Model class
    class Model
      
      include Utils
      include AtomFinder
      include ResidueFinder
      include ChainFinder

      include HetatmFinder
      include HeterogenFinder

      include Enumerable
      include Comparable
      
      attr_accessor :model_serial
      attr_reader :structure
      attr_reader :solvents

      def initialize(model_serial = nil, structure = nil)
        
        @model_serial = model_serial
        
        @structure    = structure
        
        @chains       = Array.new
        @solvents     = Chain.new('', self)
        
      end

      attr_reader :chains
      attr_reader :solvents
      
      #Adds a chain
      def addChain(chain)
        raise "Expecting a Bio::PDB::Chain" if not chain.is_a? Bio::PDB::Chain
        @chains.push(chain)
        self        
      end
      
      #adds a solvent molecule
      def addSolvent(solvent)
        raise "Expecting a Bio::PDB::Residue" if not solvent.is_a? Bio::PDB::Residue
        @solvents.addResidue(solvent)
      end

      def removeSolvent
        @solvents = nil
      end

      #Chain iterator
      def each(&x) #:yields: chain
        @chains.each(&x)
      end
      #Alias to override ChainFinder#each_chain
      alias each_chain each
     
      #Sorts models based on serial number
      def <=>(other)
        return @model_serial <=> other.model_serial
      end
      
      #Keyed access to chains
      def [](key)
        chain = @chains.find{ |chain| key == chain.id }
      end
      
      #stringifies to chains
      def to_s
        string = ""
        if model_serial
          string = "MODEL     #{model_serial}" #Should use proper formatting
        end
        @chains.each{ |chain| string << chain.to_s }
        if solvent
          string << @solvent.to_s
        end
        if model_serial
          string << "ENDMDL"
        end
        return string
      end
      
    end #class Model

  end

end
