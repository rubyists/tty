# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation
      class AlignmentSet
        include Enumerable

        # Initialize an AlignmentSet
        #
        # @param [Array] alignments
        #
        # @api public
        def initialize(alignments = nil)
          @alignments = alignments || []
        end

        # Iterate over each alignment in the set
        #
        # @example
        #   alignment_set = AlignmentSet.new alignments
        #   alignment_set.each { |alignment| ... }
        #
        # @yield [alignment]
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          to_ary.each { |alignment| yield alignment }
          self
        end

        # Lookup an alignment by index
        #
        # @param [Integer]
        #
        # @return [Symbol] alignment
        #
        # @api public
        def [](index)
          @alignments.fetch(index) do |alignment_index|
            :left
          end
        end

        # Return each alignment in an Array
        #
        # @return [Array]
        #
        # @api private
        def alignments
          map { |alignment| alignment }
        end

        # @return [Array]
        #
        # @api public
        def to_ary
          @alignments
        end

        # @return [Array]
        #
        # @api public
        def to_a
          @alignments
        end

        # @return [Boolean]
        #
        # @api public
        def empty?
          to_ary.empty?
        end

        # Align the supplied rows with the correct alignment
        #
        # @param [Array] rows
        #
        # @return [Array]
        #   the aligned rows
        #
        # @api private
        def align_rows(rows, options={})
          rows.map { |row| align_row(row, options) }
        end

      private

        # Align each cell in a row
        #
        # @param [Object] row
        #
        # @param [Hash] options
        #
        # @return [String]
        #
        # @api private
        def align_row(row, options={})
          line = ""
          row.each_with_index do |cell, index|
            column_width = options[:column_widths][index]
            alignment = case self[index]
            when :left
              '-'
            when :right
              ''
            end

            if index == row.size - 1
              line <<  "%#{alignment}#{column_width}s" % cell.to_s
            else
              line << "%#{alignment}#{column_width}s " % cell.to_s
            end
          end
          line
        end

      end # AlignmentSet
    end # Operation
  end # Table
end # TTY